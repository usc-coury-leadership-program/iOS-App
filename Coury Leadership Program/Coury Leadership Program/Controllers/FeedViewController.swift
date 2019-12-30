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
    
    private var hasProfile: Bool = false
    private var hasFeed: Bool = false
    internal var lastUpdated: Date = Date()

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
        
        if (BasicInformation.uid == nil) && !CLPProfile.shared.isSigningIn {
            // stop fetching CLPProfile so that user's selections don't get overwritten by empty database documents
            CLPProfile.shared.stopFetching()
            presentSignInVC()
        }
        
        CLPProfile.shared.onFetchSuccess {
            print("FeedViewController received CLPProfile callback")
            self.hasProfile = true
            self.possiblyUpdate()
        }
        Feed.shared.onFetchSuccess {
            print("FeedViewController received Feed callback")
            self.hasFeed = true
            self.possiblyUpdate()
        }
        
        if Feed.shared.posts.lastModified > lastUpdated {
            possiblyUpdate()
        }
    }
    
    func possiblyUpdate() {
        if hasProfile && hasFeed {
            updateTableView()
        }
    }

    @IBAction func unwindToFeed(_ unwindSegue: UIStoryboardSegue) {}
    func presentSignInVC() {self.performSegue(withIdentifier: "SignInSegue", sender: self)}
}
