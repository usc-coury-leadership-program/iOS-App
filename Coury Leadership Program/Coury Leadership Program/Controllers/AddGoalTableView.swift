//
//  AddGoalTableView.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 1/7/20.
//  Copyright © 2020 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension AddGoalViewController: UITableViewDataSource, UITableViewDelegate {

    // Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21
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
        return selectedSegment == 0 ? Self.activeRecommendations.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedSegment == 0 ? Self.activeValueForRecs : "Manual Entry"
    }

    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecommendedCell.insideOf(tableView, at: indexPath) as! RecommendedCell
        cell.textView.text = selectedSegment == 0 ? Self.activeRecommendations[indexPath.row] : "What would you like to accomplish? Tap here to type"
        cell.textView.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RecommendedCell else {return}
        cell.delegate = self
        cell.textView.isUserInteractionEnabled = true
        cell.textView.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RecommendedCell else {return}
        cell.delegate = nil
        cell.textView.isUserInteractionEnabled = false
        cell.textView.resignFirstResponder()
    }

    //MARK: - convenience functions
    func engageTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        RecommendedCell.registerWith(tableView)
//
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.contentInset = UIEdgeInsets.zero
//        tableView.estimatedRowHeight = RecommendedCell.HEIGHT
//        tableView.rowHeight = UITableView.automaticDimension
    }

    func updateTableView() {
//        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }
}
