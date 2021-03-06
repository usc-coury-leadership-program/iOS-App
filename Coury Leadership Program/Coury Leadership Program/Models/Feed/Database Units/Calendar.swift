//
//  Calendar.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Calendar: TimestampedClass, TableableCellData {
    public let CorrespondingView: TableableCell.Type = CalendarCell.self
    
    private(set) var events: [Event] {
        didSet {
            lastModified = Date()
        }
    }
    
    required public init(documents: [Event]) {
        self.events = documents
        super.init()
        // Self.self is equivalent to Calendar.self
        Database.shared.register(Self.self) {self.checkFetchSuccess()}// gets called every fetch
        if !overwriteLocalWithDatabase() {
            Self.onFetchSuccess {self.overwriteLocalWithDatabase()}// gets called first fetch
        }
    }
}

extension Calendar: Fetchable {
    public static let queryPath: String = "Calendar"
    public static let queryOrderField: String? = "start_time"
    public static let queryShouldDescend: Bool? = false
    
    public var localValue: Calendar {
        get {return self}
        set {events = newValue.events}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var process: Timer? = nil
}

extension Calendar: Hashable {
    public static func == (lhs: Calendar, rhs: Calendar) -> Bool {
        return lhs.events == rhs.events
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(events)
    }
}

extension Calendar {
    public struct Event: DBDocumentParser, Hashable {
        let name: String
        let start: Date
        let end: Date?
        let location: String?
        let uid: String
        
        init(name: String, start: Date, end: Date?, location: String?, uid: String) {
            self.name = name
            self.start = start
            self.end = end
            self.location = location
            self.uid = uid
        }
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            let uid = dbDocument.documentID
            let data = dbDocument.data()!
            
            var name: String = ""
            var startTime: Timestamp = Timestamp()
            var endTime: Timestamp?
            var location: String?

            for entry in data {
                switch entry.key {
                case "name":
                    name = entry.value as! String
                case "start_time":
                    startTime = entry.value as! Timestamp
                case "end_time":
                    endTime = (entry.value as! Timestamp)
                case "location":
                    location = (entry.value as! String)
                default:
                    break
                }
            }
            
            return Event(name: name, start: startTime.dateValue(), end: endTime?.dateValue(), location: location, uid: uid)
        }
    }
}
