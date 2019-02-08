//
//  Calendar.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation

public struct Calendar {
    let events: [CalendarEvent]
}

public struct CalendarEvent {
    let name: String
    let date: Date
}
