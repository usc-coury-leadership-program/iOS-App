//
//  ProfileViewTableView.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    // Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    // Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = Database.shared.content.thatsBeenLiked[indexPath.row]
        return content.CorrespondingView.HEIGHT
    }
    // Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = Database.shared.content.thatsBeenLiked.count
        return count
    }

    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = Database.shared.content.thatsBeenLiked[indexPath.row]
        return content.generateCellFor(tableView, at: indexPath)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Database.shared.content.thatsBeenLiked.count == 0 {return}
        let content = Database.shared.content.thatsBeenLiked[indexPath.row]
        (cell as? FeedViewCell)?.showShadow()
        (cell as? FeedViewCell)?.setSaved(to: CLPProfile.shared.hasSavedContent(for: content))
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
        tableView.contentInset = UIEdgeInsets(top: visualEffectHeader.frame.maxY + 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        tableView.estimatedRowHeight = CalendarCell.HEIGHT
    }

    func updateTableView() {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func hideTableView(_ shouldHide: Bool) {
        tableView.isHidden = shouldHide
        tableView.isUserInteractionEnabled = !shouldHide
    }
}
