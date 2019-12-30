//
//  AnsweredPolls.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class AnsweredPolls: TimestampedClass {
    public var polls: [String : Poll] {
        didSet {
            lastModified = Date()
        }
    }

    public init(polls: [Poll]) {
        self.polls = polls.reduce(into: [String : Poll]()) {
            $0[$1.uid] = $1
        }
        super.init()
        // Self.self is equivalent to AnsweredPolls.self
        Database.shared.register(Self.self) {self.checkFetchSuccess()}// gets called every fetch
        if !overwriteLocalWithDatabase() {
            Self.onFetchSuccess {self.overwriteLocalWithDatabase()}// gets called first fetch
        }
    }
 
    public required convenience init(documents: [Poll]) {
        self.init(polls: documents)
    }
}

extension AnsweredPolls: Fetchable {
    public static var queryPath: String {return "Users/{UserID}/AnsweredPolls"}
    public static let queryOrderField: String? = nil
    public static let queryShouldDescend: Bool? = nil
    
    public var localValue: AnsweredPolls {
        get {return self}
        set {polls = newValue.polls}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var process: Timer? = nil
}

extension AnsweredPolls: Hashable {
    public static func == (lhs: AnsweredPolls, rhs: AnsweredPolls) -> Bool {
        return lhs.polls == rhs.polls
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(polls)
    }
}

extension AnsweredPolls {
    public struct Poll: DBDocumentParser, Uploadable, Hashable {
        public let uid: String
        public let selection: Int
        public let timestamp: Timestamp
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            return Poll(uid: dbDocument.documentID, selection: dbDocument.data()!["selection"] as! Int, timestamp: dbDocument.data()!["timestamp"] as! Timestamp)
        }
        
        public var uploadPath: String {return "Users/{UserID}/AnsweredPolls/\(uid)"}
        
        public func inject(into dbDocument: DocumentReference) {
            dbDocument.setData([
                "selection": selection,
                "timestamp": timestamp
            ])
        }
    }
}
