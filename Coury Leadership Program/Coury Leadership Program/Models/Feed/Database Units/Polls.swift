//
//  Poll.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Polls: TimestampedClass {
    private(set) var polls: [Poll] {
        didSet {
            lastModified = Date()
        }
    }
    
    required public init(documents: [Poll]) {
        self.polls = documents
        super.init()
        // Self.self is equivalent to Polls.self
        Database.shared.register(Self.self) {self.checkFetchSuccess()}// gets called every fetch
        if !overwriteLocalWithDatabase() {
            Self.onFetchSuccess {self.overwriteLocalWithDatabase()}// gets called first fetch
        }
    }
}

extension Polls: Fetchable {
    public static let queryPath: String = "Polls"
    public static let queryOrderField: String? = "timestamp"
    public static let queryShouldDescend: Bool? = true
    
    public var localValue: Polls {
        get {return self}
        set {polls = newValue.polls}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var process: Timer? = nil
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
    public class Poll: DBDocumentParser, Uploadable, TableableCellData, Hashable {
        public let CorrespondingView: TableableCell.Type = PollCell.self

        let question: String
        let answers: [String]
        var selectedAnswer: Int?
        public let uid: String
        
        required init(question: String, answers: [String], uid: String) {
            self.question = question
            self.answers = answers
            self.uid = uid
        }
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            let uid = dbDocument.documentID
            let data = dbDocument.data()!
            
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
            
            return Poll(question: title, answers: options, uid: uid)
        }
        
        public var uploadPath: String {return "Polls/\(uid)"}
        
        public func inject(into dbDocument: DocumentReference) {
            guard let selectedAnswer = selectedAnswer else {
                print("Failed to updae poll counts: ID: \(uid), no answer has been selected yet")
                return
            }
            
            dbDocument.getDocument { (snapshot, error) in
                if let error = error {
                    print("Failed to update poll counts: ID: \(self.uid), \(error.localizedDescription)")
                    return
                }
                guard let data = snapshot?.data() else {
                    print("Failed to update poll counts: ID: \(self.uid), snapshot was nil")
                    return
                }
                
                var options: [[String : Int]] = data["Options"] as! [[String : Int]]
                let responses = options[selectedAnswer].first!
                // NOTE: adding 1 here means that users could potentially vote more than once
                // Thus, we're relying on the UI to hide poll from them
                options[selectedAnswer] = [responses.key : responses.value + 1]
                
                dbDocument.setData([
                    "Options": options
                ], merge: true)
            }
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
