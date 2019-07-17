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
    let content: [FeedableData]

    func pollsToAnswer() -> [Poll] {
        return polls.filter({$0.needsToBeAnswered() ?? false})
    }
}

//let exampleCalendar = Calendar(events: [
//    CalendarEvent(name: "Intro Lecture", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 0.0)!)),
//    CalendarEvent(name: "Guest Speaker", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 1.0)!)),
//    CalendarEvent(name: "Cohort Meeting", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 2.0)!))
//])
//
//let exampleContent: [FeedableData] = [
//    Link(url: URL(string: "https://www.business.com/")!, squareImage: UIImage(named: "first")!),
//    Quote(quoteText: "\"Inspirational quotes are very inspirational, even in the hardest of times\"", author: "iOS Developer")
//]
//
//let exampleFeed = Feed(calendar: exampleCalendar, polls: [], content: exampleContent)

