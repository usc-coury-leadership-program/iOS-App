//
//  Calendar.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Calendar: FeedableData {

    public static let empty: Calendar = Calendar(events: [])

    let events: [CalendarEvent]

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = CalendarCell.generateCellFor(tableView, at: indexPath) as! CalendarCell
        cell.calendar = self
        return cell
    }

}

public struct CalendarEvent {
    let name: String
    let date: Date
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
