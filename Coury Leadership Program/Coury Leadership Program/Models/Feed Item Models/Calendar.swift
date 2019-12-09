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

    let events: [(name: String, start: Date, end: Date?, location: String?)]
    
    public static func == (lhs: Calendar, rhs: Calendar) -> Bool {
        return lhs.events.elementsEqual(rhs.events) {(arg0, arg1) in
            let (name0, start0, end0, loc0) = arg0
            let (name1, start1, end1, loc1) = arg1
            return (name0 == name1) && (start0 == start1) && (end0 == end1) && (loc0 == loc1)
        }
    }
    public func hash(into hasher: inout Hasher) {
        for event in events {
            hasher.combine(event.name)
            hasher.combine(event.start)
            hasher.combine(event.end)
            hasher.combine(event.location)
        }
    }
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
