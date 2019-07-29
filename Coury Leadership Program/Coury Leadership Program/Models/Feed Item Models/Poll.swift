//
//  Poll.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Poll: TableableCellData {
    public let CorrespondingView: TableableCell.Type = PollCell.self

    let question: String
    let answers: [String]
    let id: Int

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
    var thatNeedAnswering: [Poll] {
        return self.filter({$0.needsToBeAnswered() ?? false})
    }
}
