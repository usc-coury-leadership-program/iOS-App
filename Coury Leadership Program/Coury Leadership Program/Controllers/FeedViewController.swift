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
    var handle: AuthStateDidChangeListenerHandle?

    var feedFetchingTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engageTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Feed
        Feed.shared.onFetchSuccess {self.updateTableView()}
        Feed.shared.beginFetching()
        // Profile
        if CLPProfile.shared.id != nil {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in self.updateFirebaseConnectedComponents()}
            self.updateFirebaseConnectedComponents()
        }
        else if !CLPProfile.shared.isSigningIn {presentSignInVC()}
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Feed
        Feed.shared.clearFetchSuccessCallbacks()
        Feed.shared.stopFetching()
        // Profile
        if handle != nil {Auth.auth().removeStateDidChangeListener(handle!)}
    }

    func presentSignInVC() {self.performSegue(withIdentifier: "SignInSegue", sender: self)}

    func updateFirebaseConnectedComponents() {
        Database.shared.fetchUserProfile(CLPProfile.shared) {
            self.updatePolls()
            self.updateSaved()
        }
    }

    func updatePolls() {self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)}
    func updateSaved() {self.tableView.layoutSubviews()}
}


