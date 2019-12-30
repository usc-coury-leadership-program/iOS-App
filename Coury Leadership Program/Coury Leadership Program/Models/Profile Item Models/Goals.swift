//
//  Goal.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 8/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Goals: TimestampedClass {
    public var goals: [Goal] {
        didSet {
            lastModified = Date()
        }
    }
    
    public init(goals: [Goal]) {
        self.goals = goals
        super.init()
        // Self.self is equivalent to Goals.self
        Database2.shared.register(Self.self) {self.checkFetchSuccess()}// gets called every fetch
        if !overwriteLocalWithDatabase() {
            Self.onFetchSuccess {self.overwriteLocalWithDatabase()}// gets called first fetch
        }
    }
    
    public required convenience init(documents: [Goal]) {
        self.init(goals: documents)
    }
}

extension Goals: Fetchable2 {
    public static var queryPath: String {return "Users/{UserID}/Goals"}
    public static let queryOrderField: String? = nil
    public static let queryShouldDescend: Bool? = nil
    
    public var localValue: Goals {
        get {return self}
        set {goals = newValue.goals}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var process: Timer? = nil
}

extension Goals: Hashable {
    public static func == (lhs: Goals, rhs: Goals) -> Bool {
        return lhs.goals == rhs.goals
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(goals)
    }
}

extension Goals {
    public class Goal: DBDocumentParser, Uploadable, TableableCellData, Hashable {
        public let CorrespondingView: TableableCell.Type = GoalCell.self
        
        var text: String = ""
        var strength: String?
        var value: String?
        var achieved: Bool = false
        public var uid: String
    
        init(text: String, strength: String?, value: String?, achieved: Bool, uid: String?) {
            self.text = text
            self.strength = strength
            self.value = value
            self.achieved = achieved
            self.uid = uid ?? "{NewDoc}\(String(format: "%.10f", Float.random(in: 0..<1)).suffix(10))"
        }
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            let uid = dbDocument.documentID
            let data = dbDocument.data()!
            
            var text: String = "", strength: String?, value: String?, achieved: Bool = false
            for entry in data {
                switch entry.key {
                case "text": text = (entry.value as! String)
                case "strength": strength = (entry.value as! String)
                case "value": value = (entry.value as! String)
                case "achieved": achieved = (entry.value as! Bool)
                default: break
                }
            }
            
            return Goal(text: text, strength: strength, value: value, achieved: achieved, uid: uid)
        }
        
        public var uploadPath: String {return "Users/{UserID}/Goals/\(uid)"}
        
        public func inject(into dbDocument: DocumentReference) {
            uid = dbDocument.documentID// must update, since it could be {NewDoc}...
            
            var dict: [String: Any] = ["text": text, "achieved": achieved]
            if let strength = strength {dict["strength"] = strength}
            if let value = value {dict["value"] = value}
            
            dbDocument.setData(dict)
        }
        
        // MARK: Hashable
        public static func == (lhs: Goals.Goal, rhs: Goals.Goal) -> Bool {
            return (lhs.uid == rhs.uid)
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }
    }
}
