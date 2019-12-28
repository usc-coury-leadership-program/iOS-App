//
//  Calendar.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Calendar: HashableTypeSeed, TableableCellData {
    public let CorrespondingView: TableableCell.Type = CalendarCell.self
    
    private(set) var events: [Event]
    // uid is just here to conform to TableableCellData
    // could combine Event uid's to create a real one
    public let uid: String = ""
    public let shouldDisplay: Bool = true
    
    required public init(documents: [Event]) {
        super.init()
        self.events = documents
    }
}


extension Calendar: Fetchable2 {
    public static let queryPath: String = "Calendar"
    public static let queryOrderField: String = "start_time"
    public static let queryShouldDescend: Bool = true
    
    public var localValue: Calendar {
        get {return self}
        set {events = newValue.events}
    }
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
    public struct Event: Hashable, QueryDocumentConverter {
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
        
        public init(dbDocument: QueryDocumentSnapshot) {
            let uid = dbDocument.documentID
            let data = dbDocument.data()
            
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
            
            self.init(name: name, start: startTime.dateValue(), end: endTime?.dateValue(), location: location, uid: uid)
        }
    }
}
