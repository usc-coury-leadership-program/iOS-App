//
//  FeedViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    internal var currentOrder: [Int]?
    internal var gotCalendar = false
    internal var gotPolls = false
    internal var gotContent = false
    var handle: AuthStateDidChangeListenerHandle?

    var feedFetchingTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engageTableView()
        registerFeedCallbacks()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLPUser.shared().id != nil {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in self.updateFirebaseConnectedComponents()}
            self.updateFirebaseConnectedComponents()
            self.startFetchingFeed()
        }
        else if !CLPUser.shared().isSigningIn {presentSignInVC()}
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if handle != nil {Auth.auth().removeStateDidChangeListener(handle!)}
        self.stopFetchingFeed()
//        gotCalendar = false
//        gotPolls = false
//        gotContent = false
    }

    func presentSignInVC() {self.performSegue(withIdentifier: "SignInSegue", sender: self)}

    func updateFirebaseConnectedComponents() {
        Database.shared.fetchUserProfile(CLPUser.shared()) {
            self.updatePolls()
            self.updateSaved()
        }
    }

    func updatePolls() {self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)}
    func updateSaved() {self.tableView.layoutSubviews()}
    func startFetchingFeed() {
        stopFetchingFeed()
        let calendarTimer = Timer(timeInterval: 1.0, repeats: true) {timer in
            if self.gotCalendar {timer.invalidate(); return}
            Database.shared.fetchCalendar()
        }
        let pollTimer = Timer(timeInterval: 1.0, repeats: true) {timer in
            if self.gotPolls {timer.invalidate(); return}
            Database.shared.fetchPolls()
        }
        let contentTimer = Timer(timeInterval: 1.0, repeats: true) {timer in
            if self.gotContent {timer.invalidate(); return}
            Database.shared.fetchContent()
        }
        RunLoop.current.add(calendarTimer, forMode: .common)
        RunLoop.current.add(pollTimer, forMode: .common)
        RunLoop.current.add(contentTimer, forMode: .common)
        feedFetchingTimers = [calendarTimer, pollTimer, contentTimer]
    }
    func stopFetchingFeed() {
        for timer in feedFetchingTimers {timer.invalidate()}
    }
    func registerFeedCallbacks() {// TODO callback ids so that we can remove them later
        Database.shared.registerCalendarCallback {
            self.gotCalendar = true
            self.updateTableView()
        }
        Database.shared.registerPollsCallback {
            self.gotPolls = true
            self.updateTableView()
        }
        Database.shared.registerContentCallback {
            self.gotContent = true
            self.updateTableView()
        }
    }
}


