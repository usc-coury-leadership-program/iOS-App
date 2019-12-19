//
//  Calendar.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Calendar: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = CalendarCell.self
    
    struct Event: Identifiable, Hashable {
        let name: String
        let start: Date
        let end: Date?
        let location: String?
        public let uid: String
    }

    let events: [Event]
    
    public static func == (lhs: Calendar, rhs: Calendar) -> Bool {return lhs.events == rhs.events}
    public func hash(into hasher: inout Hasher) {hasher.combine(events)}
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }

    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        return dateFormatter.string(from: self)
    }
}
