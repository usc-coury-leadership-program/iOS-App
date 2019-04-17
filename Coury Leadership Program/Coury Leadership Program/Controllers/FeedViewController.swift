//
//  FeedViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import GoogleSignIn

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var currentFeed = Feed(calendar: Calendar(events: []), polls: [], content: [])
    private var needsFeedUpdateAfterSignIn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engageTableView()
        if CLPUser.shared().uid != nil {updateFeed()}
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if CLPUser.shared().uid == nil {
            print("We gotta sign in!")
            needsFeedUpdateAfterSignIn = true
            presentSignInVC()
        }else if (needsFeedUpdateAfterSignIn) {
            updateFeed()
            needsFeedUpdateAfterSignIn = false
        }
        if CLPUser.shared().strengths == nil {
            print("We gotta do some extra sign in stuff!")
        }
    }

    func presentSignInVC() {
        //let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
        //self.present(signInVC, animated: true, completion: nil)

        self.performSegue(withIdentifier: "SignInSegue", sender: self)
    }

    func updateFeed() {
        Database.shared().fetchCalendar() {(calendar) in
            self.currentFeed = Feed(calendar: calendar, polls: self.currentFeed.polls, content: self.currentFeed.content)
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        Database.shared().fetchPolls() {(polls) in
            self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: polls, content: self.currentFeed.content)
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
        Database.shared().fetchContent() {(content) in
            self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: self.currentFeed.polls, content: content)
            self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
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

    // Cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? FeedableCell else {return}
        cell.onTap()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //TODO: reset tapCount on all cells
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
