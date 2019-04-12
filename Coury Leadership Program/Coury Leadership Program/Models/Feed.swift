//
//  Feed.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import FirebaseFirestore

public struct Feed {
    let calendar: Calendar
    let polls: [Poll]
    let content: [FeedableData]
}


let exampleCalendar = Calendar(events: [
    CalendarEvent(name: "Intro Lecture", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 0.0)!)),
    CalendarEvent(name: "Guest Speaker", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 1.0)!)),
    CalendarEvent(name: "Cohort Meeting", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 2.0)!))
])
let exampleContent: [FeedableData] = [
    Link(url: URL(string: "https://www.business.com/")!, squareImage: UIImage(named: "first")!),
    Quote(quoteText: "\"Inspirational quotes are very inspirational, even in the hardest of times\"", author: "iOS Developer")
]
let exampleFeed = Feed(calendar: exampleCalendar, polls: [], content: exampleContent)


public func fetchCalendar() {
    let db = Firestore.firestore()

    db.collection("Feed").document("Calendar").getDocument() { (dbCalendar, error) in
        if error != nil {return print(Calendar(events: []))}
        else {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d h:mma"// VVV"
            var events: [CalendarEvent] = []

            for dbEvent in dbCalendar!.data()! {
                let dateString = (dbEvent.value as! String)// + " Los Angeles"
                print(dateString)
                let date = dateFormatter.date(from: dateString)!
                let event = CalendarEvent(name: dbEvent.key, date: date)
                events.append(event)
            }

            print(Calendar(events: events))
        }
    }
//    db.collection("Feed").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//            for document in querySnapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
//            }
//        }
//    }
}
