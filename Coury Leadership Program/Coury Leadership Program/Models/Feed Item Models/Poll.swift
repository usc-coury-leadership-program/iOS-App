//
//  Poll.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Poll: FeedableData {

    let question: String
    let answers: [String]

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = PollCell.generateCellFor(tableView, at: indexPath) as! PollCell
        cell.questionText.text = question
        return cell
    }

}
