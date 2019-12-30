//
//  FeedViewTableView.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {

    // Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    // Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return CalendarCell.HEIGHT
        case 1: return PollCell.HEIGHT
        case 2:
            let post = Feed.shared.posts.posts[indexPath.row]
            return post.CorrespondingView.HEIGHT
        default: return 30
        }
    }
    // Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return Feed.shared.polls.polls.unanswered.count
        case 2: return Feed.shared.posts.posts.count
        default: return 0
        }
    }

    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0: return Feed.shared.calendar.generateCellFor(tableView, at: indexPath)
        case 1: return Feed.shared.polls.polls.unanswered[indexPath.row].generateCellFor(tableView, at: indexPath)
        case 2: return Feed.shared.posts.posts[indexPath.row].generateCellFor(tableView, at: indexPath)
        default: fatalError("TableView @ FeedViewController has more sections than expected")
        }
    }
    // Cell display
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        case 1: break
        case 2:
            let post = Feed.shared.posts.posts[indexPath.row]
            (cell as? FeedViewCell)?.setSaved(to: post.liked)
        default: break
        }
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
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
        lastUpdated = Date()
    }
}
