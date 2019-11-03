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
            let content = Database.shared.content[FeedViewController.indexPathMapping?(indexPath) ?? indexPath.row]
            if let _ = content as? Link {return LinkCell.HEIGHT}
            else if let _ = content as? Image {return ImageCell.HEIGHT}
            else if let _ = content as? Quote {return QuoteCell.HEIGHT}
            else {return 30}
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
        case 1: return Database.shared.polls.thatNeedAnswering.count
        case 2:
            let count = isJustShowingSaved ? (CLPProfile.shared.savedContent?.count ?? 0) : Database.shared.content.count
            nothingSavedMessage.isHidden = !(isJustShowingSaved && count == 0)
            return count
        default: return 0
        }
    }

    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0: return Database.shared.calendar.generateCellFor(tableView, at: indexPath)
        case 1: return Database.shared.polls.thatNeedAnswering[indexPath.row].generateCellFor(tableView, at: indexPath)// TODO if one of the polls gets answered, but then the user scrolls down and back up, the tableView will try to regenerate it. But it wont find it in this array, resulting in array out of bounds.
        case 2: return Database.shared.content[FeedViewController.indexPathMapping?(indexPath) ?? indexPath.row].generateCellFor(tableView, at: indexPath)
        default: fatalError("Feed's TableView has more sections than expected.")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? FeedViewCell)?.showShadow()
        (cell as? FeedViewCell)?.setSaved(to: CLPProfile.shared.savedContent?.contains(FeedViewController.indexPathMapping?(indexPath) ?? indexPath.row) ?? false)
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
        if currentOrder == nil {currentOrder = ([Int](0...Database.shared.content.count - 1)).shuffled()}
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func shuffled(_ indexPath: IndexPath) -> Int {
        return currentOrder?[indexPath.row] ?? indexPath.row
    }
    
    func saved(_ indexPath: IndexPath) -> Int {
        return CLPProfile.shared.savedContent?[indexPath.row] ?? indexPath.row
    }
}
