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

    let events: [(name: String, date: Date)]
    
    public static func == (lhs: Calendar, rhs: Calendar) -> Bool {
        return lhs.events.elementsEqual(rhs.events) {(arg0, arg1) in
            let (name0, date0) = arg0
            let (name1, date1) = arg1
            return (name0 == name1) && (date0 == date1)
        }
    }
    public func hash(into hasher: inout Hasher) {
        for event in events {
            hasher.combine(event.name)
            hasher.combine(event.date)
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
