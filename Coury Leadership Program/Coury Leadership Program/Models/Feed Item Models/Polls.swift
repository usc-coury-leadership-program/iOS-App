//
//  Poll.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Polls: HashableTypeSeed {
    private(set) var polls: [Poll]
    
    required public init(documents: [Poll]) {
        super.init()
        self.polls = documents
    }
}

extension Polls: Fetchable2 {
    public static let queryPath: String = "Polls"
    public static let queryOrderField: String = "timestamp"
    public static let queryShouldDescend: Bool = true
    
    public var localValue: Polls {
        get {return self}
        set {polls = newValue.polls}
    }
}

extension Polls: Hashable {
    public static func == (lhs: Polls, rhs: Polls) -> Bool {
        return lhs.polls == rhs.polls
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(polls)
    }
}


extension Polls {
    public struct Poll: Hashable, QueryDocumentConverter, TableableCellData {
        public let CorrespondingView: TableableCell.Type = PollCell.self

        let question: String
        let answers: [String]
        public let uid: String
        public var shouldDisplay: Bool {return !CLPProfile.shared.has(answeredPoll: uid)}
        
        init(question: String, answers: [String], uid: String) {
            self.question = question
            self.answers = answers
            self.uid = uid
        }
        
        public init(dbDocument: QueryDocumentSnapshot) {
            let uid = dbDocument.documentID
            let data = dbDocument.data()
            
            var title: String = ""
            var options: [String] = []

            for entry in data {
                switch entry.key {
                case "title":
                    title = entry.value as! String
                case "Options":
                    let option_arr = entry.value as! [[String : Int]]
                    options = option_arr.map({$0.keys.first!})
                default:
                    break
                }
            }
            
            self.init(question: title, answers: options, uid: uid)
        }

        public func markAsAnswered(with choice: Int) {
            togglePollAnsweredStatus()
            Database.shared.sendPollResponse(self, choice: choice)
        }
        
        public func togglePollAnsweredStatus() {
            CLPProfile.shared.add(answeredPoll: uid)
        }
        
        // MARK: Hashable
        public static func == (lhs: Polls.Poll, rhs: Polls.Poll) -> Bool {
            return lhs.uid == rhs.uid
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }
    }
}
