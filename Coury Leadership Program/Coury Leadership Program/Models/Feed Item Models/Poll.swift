//
//  Poll.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Poll: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = PollCell.self

    let question: String
    let answers: [String]
    public let uid: String
    public var shouldDisplay: Bool {
        get {return !CLPProfile.shared.has(answeredPoll: uid)}
    }

    public func markAsAnswered(with choice: Int) {
        togglePollAnsweredStatus()
        Database.shared.sendPollResponse(self, choice: choice)
    }
    
    public func togglePollAnsweredStatus() {
        CLPProfile.shared.add(answeredPoll: uid)
    }
    
    public static func == (lhs: Poll, rhs: Poll) -> Bool {return lhs.uid == rhs.uid}
    public func hash(into hasher: inout Hasher) {hasher.combine(uid)}
}
