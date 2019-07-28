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

    //private var currentFeed = Feed(calendar: Calendar(events: []), polls: [], content: [])
    private var currentOrder: [Int]?
    private var gotCalendar = false
    private var gotPolls = false
    private var gotContent = false
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


    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let cell = tableView.cellForRow(at: indexPath)!
                (cell as? FeedableCell)?.onTap(inContext: self)

                UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                }, completion: nil)
            }
        }
    }

    @IBAction func onLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            guard let cell = tableView.cellForRow(at: indexPath) as? FeedableCell else {return}

            switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    cell.onLongPress(began: true)
                }, completion: nil)

                if indexPath.section == 2 {CLPUser.shared().toggleSavedContent(for: shuffled(indexPath))}
                
            default:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    cell.onLongPress(began: false)
                }, completion: nil)
            }
        }
    }

    @IBAction func onSwipeGesture(_ sender: UISwipeGestureRecognizer) {
//        print("Noticed swipe!")
//        print(sender.location(in: tableView))
    }

}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {

    // Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0}
    // Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return CalendarCell.HEIGHT
        case 1: return PollCell.HEIGHT
        case 2:
            let content = Database.shared.content[shuffled(indexPath)]
            if let _ = content as? Link {return LinkCell.HEIGHT}
            else if let _ = content as? Image {return ImageCell.HEIGHT}
            else if let _ = content as? Quote {return QuoteCell.HEIGHT}
            else {return 30}

        default: return 30
        }
    }
    // Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}

    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {return 3}
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return Database.shared.polls.pollsToAnswer.count//currentFeed.pollsToAnswer().count
        case 2: return Database.shared.content.count//currentFeed.content.count
        default: return 0
        }
    }

    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0: return Database.shared.calendar.generateCellFor(tableView, at: indexPath)
        case 1: return Database.shared.polls.pollsToAnswer[indexPath.row].generateCellFor(tableView, at: indexPath)
        case 2: return Database.shared.content[shuffled(indexPath)].generateCellFor(tableView, at: indexPath)
        default: fatalError("Feed's TableView has more sections than expected.")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? FeedableCell)?.showShadow()
        (cell as? FeedableCell)?.setSaved(to: CLPUser.shared().savedContent?.contains(shuffled(indexPath)) ?? false)
        //(cell as! FeedableCell).isSaved = CLPUser.shared().savedContent?.contains(indexPath.row) ?? false
    }

    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        CalendarCell.registerWith(tableView)
        PollCell.registerWith(tableView)
        LinkCell.registerWith(tableView)
        ImageCell.registerWith(tableView)
        QuoteCell.registerWith(tableView)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.estimatedRowHeight = CalendarCell.HEIGHT
    }

    func updateTableView() {
        if gotCalendar && gotPolls && gotContent {
            if currentOrder == nil {currentOrder = ([Int](0...Database.shared.content.count - 1)).shuffled()}
            print("Updated table view")
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    func shuffled(_ indexPath: IndexPath) -> Int {return currentOrder?[indexPath.row] ?? indexPath.row}
}
