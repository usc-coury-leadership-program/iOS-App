//
//  FeedViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import CoreMotion
import Firebase
import GoogleSignIn

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var currentFeed = Feed(calendar: Calendar(events: []), polls: [], content: [])
    private var allAdjustShadowFunctions: [IndexPath : (Double, Double) -> Void] = [:]
    var handle: AuthStateDidChangeListenerHandle?

    private let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engageTableView()
        engageMotionShadows()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + 20.0, left: 0.0, bottom: 20.0, right: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLPUser.shared().id != nil {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in self.updateFirebaseConnectedComponents()}
        }
        else if !CLPUser.shared().isSigningIn {presentSignInVC()}
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if handle != nil {Auth.auth().removeStateDidChangeListener(handle!)}
    }

    func presentSignInVC() {self.performSegue(withIdentifier: "SignInSegue", sender: self)}

    func updateFirebaseConnectedComponents() {
        Database.shared().fetchUserProfile(CLPUser.shared()) {
            self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }
        updateFeed()
    }

    func updateFeed() {
        if self.currentFeed.calendar.events.count == 0 {
            Database.shared().fetchCalendar() {(calendar) in
                self.currentFeed = Feed(calendar: calendar, polls: self.currentFeed.polls, content: self.currentFeed.content)
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
        if self.currentFeed.polls.count == 0 {
            Database.shared().fetchPolls() {(polls) in
                self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: polls, content: self.currentFeed.content)
                self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
            }
        }
        if self.currentFeed.content.count == 0 {
            Database.shared().fetchContent() {(content) in
                self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: self.currentFeed.polls, content: content)
                self.tableView.reloadSections(IndexSet(integer: 2), with: .fade)
            }
        }
    }


    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let cell = tableView.cellForRow(at: indexPath)!
                (cell as? FeedableCell)?.onTap()

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

                CLPUser.shared().toggleSavedContent(for: indexPath.row)
                
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

extension FeedViewController {

    private func engageMotionShadows() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                guard let motion = motion else {return}
                for adjustShadow in self.allAdjustShadowFunctions.values {
                    adjustShadow(motion.attitude.pitch, motion.attitude.roll)
                }
            }
        }
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
            let content = currentFeed.content[indexPath.row]
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
        case 1: return currentFeed.polls.count
        case 2: return currentFeed.content.count
        default: return 0
        }
    }

    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0: return currentFeed.calendar.generateCellFor(tableView, at: indexPath)
        case 1: return currentFeed.polls[indexPath.row].generateCellFor(tableView, at: indexPath)
        case 2: return currentFeed.content[indexPath.row].generateCellFor(tableView, at: indexPath)
        default: fatalError("Feed's TableView has more sections than expected.")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedableCell else {return}
        allAdjustShadowFunctions[indexPath] = cell.adjustShadow(pitch:roll:)
    }

    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        CalendarCell.registerWith(tableView)
        LinkCell.registerWith(tableView)
        ImageCell.registerWith(tableView)
        QuoteCell.registerWith(tableView)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)

        tableView.reloadData()
    }
}
