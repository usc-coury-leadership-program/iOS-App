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
    
    public static var indexPathMapping: ((IndexPath) -> Int)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var safeboxButton: UIButton!
    @IBOutlet weak var nothingSavedMessage: UILabel!
    
    internal var currentOrder: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FeedViewController.indexPathMapping = self.shuffled
        engageTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Profile
        if (CLPProfile.shared.uid == nil) && !CLPProfile.shared.isSigningIn {presentSignInVC()}
        CLPProfile.shared.onFetchSuccess {self.updatePolls(); self.updateSaved()}
        // Feed
        Feed.shared.onFetchSuccess {self.updateTableView()}
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        // Profile
//        CLPProfile.shared.clearFetchSuccessCallbacks()
//        // Feed
//        Feed.shared.clearFetchSuccessCallbacks()
    }

    func presentSignInVC() {self.performSegue(withIdentifier: "SignInSegue", sender: self)}

    func updatePolls() {self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)}
    func updateSaved() {self.tableView.layoutSubviews()}
    
}


