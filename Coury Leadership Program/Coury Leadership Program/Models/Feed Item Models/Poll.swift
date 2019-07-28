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
    let id: Int

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = PollCell.generateCellFor(tableView, at: indexPath) as! PollCell
        cell.questionText.text = question
        cell.poll = self
        return cell
    }

    public func needsToBeAnswered() -> Bool? {
        let didFindID = CLPUser.shared().answeredPolls?.contains(self.id)
        if didFindID != nil {return !didFindID!}
        return didFindID
    }

    public func markAsAnswered(with response: String) {
        CLPUser.shared().addToAnsweredPolls(poll: id)
        Database.shared.sendPollResults(self, response: response)
    }
}

extension Array where Element == Poll {
    var pollsToAnswer: [Poll] {
        return self.filter({$0.needsToBeAnswered() ?? false})
    }
}
