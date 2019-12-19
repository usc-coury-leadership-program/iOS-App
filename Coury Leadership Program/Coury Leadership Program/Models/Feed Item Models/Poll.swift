//
//  Poll.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Poll: TableableCellData, Identifiable, Hashable {
    public let CorrespondingView: TableableCell.Type = PollCell.self

    let question: String
    let answers: [String]
    public let uid: String

    public func needsToBeAnswered() -> Bool {
        let didFindID = CLPProfile.shared.answeredPolls?.contains(self.uid) ?? false
        return !didFindID
    }

    public func markAsAnswered(with response: String) {
        CLPProfile.shared.addToAnsweredPolls(poll: uid)
        Database.shared.sendPollResults(self, response: response)
    }
    
    public static func == (lhs: Poll, rhs: Poll) -> Bool {return lhs.uid == rhs.uid}
    public func hash(into hasher: inout Hasher) {hasher.combine(uid)}
}

extension Array where Element == Poll {
    var thatNeedAnswering: [Poll] {
        return self.filter({$0.needsToBeAnswered()})
    }
}
