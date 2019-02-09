//
//  Feed.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Feed {
    let calendar: Calendar
    let polls: [Poll]
    let content: [Content]
}


let exampleCalendar = Calendar(events: [
    CalendarEvent(name: "Leadership Meeting 1", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 0.0)!)),
    CalendarEvent(name: "Leadership Meeting 2", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 1.0)!)),
    CalendarEvent(name: "Leadership Meeting 3", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 2.0)!))
])
let exampleContent: [Content] = [
    Link(url: URL(string: "https://www.google.com/")!, squareImage: UIImage(named: "first")!),
    Quote(quoteText: "'Inspirational quotes are very inspirational, even in the hardest of times'", emphasizedWords: [], author: "iOS Developer")
]
let exampleFeed = Feed(calendar: exampleCalendar, polls: [], content: exampleContent)
