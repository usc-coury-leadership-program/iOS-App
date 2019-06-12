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
    private var currentOrder: [Int]?
    private var gotCalendar = false
    private var gotPolls = false
    private var gotContent = false
    var handle: AuthStateDidChangeListenerHandle?
    private let motionManager = CMMotionManager()

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
        if CLPUser.shared().id != nil {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in self.updateFirebaseConnectedComponents()}
            //self.updateFirebaseConnectedComponents()
        }
        else if !CLPUser.shared().isSigningIn {presentSignInVC()}
        engageMotionShadows()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disengageMotionShadows()
        if handle != nil {Auth.auth().removeStateDidChangeListener(handle!)}
        gotCalendar = false
        gotPolls = false
        gotContent = false
    }

    func presentSignInVC() {self.performSegue(withIdentifier: "SignInSegue", sender: self)}

    func updateFirebaseConnectedComponents() {
        updateSaved()
        updateFeed()
    }

    func updateSaved() {
        Database.shared().fetchUserProfile(CLPUser.shared()) {
            if self.gotCalendar && self.gotPolls && self.gotContent {
//                self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
//                self.tableView.beginUpdates()
//                self.tableView.endUpdates()
                self.tableView.layoutSubviews()
            }
        }
    }

    func updateFeed() {
        if currentFeed.calendar.events.count == 0 {
            Database.shared().fetchCalendar() {(calendar) in
                self.currentFeed = Feed(calendar: calendar, polls: self.currentFeed.polls, content: self.currentFeed.content)
                self.gotCalendar = true
                self.updateTableView()
            }
        }else {self.gotCalendar = true}

        if currentFeed.polls.count == 0 {
            Database.shared().fetchPolls() {(polls) in
                self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: polls, content: self.currentFeed.content)
                self.gotPolls = true
                self.updateTableView()
            }
        }else {self.gotPolls = true}

        if currentFeed.content.count == 0 {
            Database.shared().fetchContent() {(content) in
                self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: self.currentFeed.polls, content: content)
                self.gotContent = true
                self.updateTableView()
            }
        }else {self.gotContent = true}
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

//                let unrandomizedIndex = currentOrder?.firstIndex(of: indexPath.row) ?? indexPath.row
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
            let content = currentFeed.content[shuffled(indexPath)]
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
        case 2: return currentFeed.content[shuffled(indexPath)].generateCellFor(tableView, at: indexPath)
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
        LinkCell.registerWith(tableView)
        ImageCell.registerWith(tableView)
        QuoteCell.registerWith(tableView)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.estimatedRowHeight = CalendarCell.HEIGHT
    }

    func updateTableView() {
        if gotCalendar && gotPolls && gotContent {
            if currentOrder == nil {currentOrder = ([Int](0...currentFeed.content.count - 1)).shuffled()}
            print("Updated table view")
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    func shuffled(_ indexPath: IndexPath) -> Int {return currentOrder?[indexPath.row] ?? indexPath.row}
}

extension FeedViewController {

    private func engageMotionShadows() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                guard let motion = motion else {return}
                for cell in self.tableView.visibleCells {
                    (cell as? FeedableCell)?.adjustShadow(pitch: motion.attitude.pitch, roll: motion.attitude.roll)
                }
            }
        }
    }

    private func disengageMotionShadows() {motionManager.stopDeviceMotionUpdates()}

}
