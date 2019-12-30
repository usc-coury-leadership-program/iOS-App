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
    public var answeredPolls: [AnsweredPoll] {
        didSet {
            lastModified = Date()
        }
    }

    public init(answeredPolls: [AnsweredPoll]) {
        self.answeredPolls = answeredPolls
        super.init()
    }
 
    public required convenience init(documents: [AnsweredPoll]) {
        self.init(answeredPolls: documents)
        // Self.self is equivalent to AnsweredPolls.self
        Database2.shared.register(Self.self) {self.checkFetchSuccess()}
    }
}

extension AnsweredPolls: Fetchable2 {
    public static var queryPath: String {return "Users/{UserID}/AnsweredPolls"}
    public static let queryOrderField: String? = nil
    public static let queryShouldDescend: Bool? = nil
    
    public var localValue: AnsweredPolls {
        get {return self}
        set {answeredPolls = newValue.answeredPolls}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var activeProcesses: [Timer] = []
}

extension AnsweredPolls: Hashable {
    public static func == (lhs: AnsweredPolls, rhs: AnsweredPolls) -> Bool {
        return lhs.answeredPolls == rhs.answeredPolls
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answeredPolls)
    }
}

extension AnsweredPolls {
    public struct AnsweredPoll: DBDocumentParser, Uploadable, Hashable {
        public let uid: String
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            return AnsweredPoll(uid: dbDocument.documentID)
        }
        
        public var uploadPath: String {return "Users/{UserID}/AnsweredPolls/\(uid)"}
        
        public func inject(into dbDocument: DocumentReference) {
            dbDocument.setData([
                "Status": true
            ])
        }
    }
}
