//
//  Database.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 4/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

public class Database {
    // shared instance
    public private(set) static var shared: Database = {
        return Database()
    }()

    // private static properties
    private static let storage = Storage.storage()
    // private instance properties
    private var lastUploadedProfile: [String : Any] = [:]
    private var calendarGotSetCallbacks: [() -> Void] = []
    private var pollsGotSetCallbacks: [() -> Void] = []
    private var contentGotSetCallbacks: [() -> Void] = []
    // public instance properties
    public private(set) var calendar = Calendar(events: []) {
        didSet {for callback in calendarGotSetCallbacks {callback()}}
    }
    public private(set) var polls: [Poll] = [] {
        didSet {for callback in pollsGotSetCallbacks {callback()}}
    }
    public private(set) var content: [TableableCellData] = [] {
        didSet {for callback in contentGotSetCallbacks {callback()}}
    }
//    public var feed: Feed {
//        return Feed(calendar: calendar, polls: polls, content: content)
//    }

    // private constructor
    private init() {
    }

    public func registerCalendarCallback(_ callback: @escaping () -> Void) -> Int {
        calendarGotSetCallbacks.append(callback)
        return calendarGotSetCallbacks.count - 1
    }
    public func registerPollsCallback(_ callback: @escaping () -> Void) -> Int {
        pollsGotSetCallbacks.append(callback)
        return pollsGotSetCallbacks.count - 1
    }
    public func registerContentCallback(_ callback: @escaping () -> Void) -> Int {
        contentGotSetCallbacks.append(callback)
        return contentGotSetCallbacks.count - 1
    }

    public func fetch() {
        fetchCalendar()
        fetchPolls()
        fetchContent()
    }
    
    public func fetchCalendar() {
        Firestore.firestore().collection("Feed").document("Calendar").getDocument { (document, error) in
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Calendar document has no data")
                    return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d yyyy h:mma"
                var events: [(name: String, date: Date)] = []
                
                for entry in data {
                    let dateString = (entry.value as! String)
                    if let date = dateFormatter.date(from: dateString) {
                        events.append((name: entry.key, date: date))
                    }else {
                        dateFormatter.dateFormat = "MMM d yyyy"
                        if let date = dateFormatter.date(from: dateString) {
                            events.append((name: entry.key, date: date))
                        }else {
                            dateFormatter.dateFormat = "MMM yyyy"
                            if let date = dateFormatter.date(from: dateString) {
                                events.append((name: entry.key, date: date))
                            }else {continue}
                        }
                    }
                }

                let sorted = events.sorted() {(event0, event1) -> Bool in
                    event0.date.compare(event1.date) == .orderedAscending
                }
                self.calendar = Calendar(events: sorted)
            }
        }
    }
    
    public func fetchPolls() {
        Firestore.firestore().collection("Feed").document("Polls").getDocument { (document, error) in
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Polls document has no data")
                    return
                }
                var polls: [Poll] = []

                for (i, question) in data.enumerated() {
                    let answers = (question.value as! [String]).map({$0.retrievePeriods()})
                    polls.append(Poll(question: question.key.retrievePeriods(), answers: answers, id: i))
                }

                self.polls = polls
            }
        }
    }

    public func fetchContent() {
        Firestore.firestore().collection("Feed").document("Content").getDocument { (document, error) in

            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Content document has no data")
                    return
                }
                var result: [TableableCellData] = []

                guard let links: [String] = data["Links"] as? [String] else {
                    print("Could not find links!")
                    return
                }
                for link in links {
                    let linkStruct: Link = Link(url: URL(string: link)!, squareImage: UIImage(color: .black)!)
                    result.append(linkStruct)
                }

                guard let images: [String] = data["Images"] as? [String] else {
                    print("Could not find images!")
                    return
                }
                for image in images {
                    let storageRef = Database.storage.reference(withPath: "Feed/Images/" + image)
                    result.append(Image(imageReference: storageRef))
                }

                guard let quotes: [Dictionary<String, String>] = data["Quotes"] as? [Dictionary<String, String>] else {
                    print("Could not finds quotes")
                    return
                }
                for quote in quotes {
                    let quoteStruct: Quote = Quote(quoteText: quote["text"]!, author: quote["author"]!)
                    result.append(quoteStruct)
                }

                self.content = result
            }
        }
    }
    
    public func fetchUserProfile(_ user: CLPUser, andRun callback: (() -> Void)?) {
        guard let uid = user.id else {return}
        Firestore.firestore().collection("Users").document(uid).getDocument { (document, error) in

            if let document = document, document.exists, let data = document.data() {
                let values: [String]? = (data["values"] as? String)?.components(separatedBy: ",")
                let strengths: [String]? = (data["strengths"] as? String)?.components(separatedBy: ",")

                var savedContent: [Int]? = nil
                if let rawSavedContent: String = data["saved content"] as? String {
                    if rawSavedContent.count > 0 {
                        savedContent = rawSavedContent.components(separatedBy: ",").map({Int($0)!})
                    }
                }

                var answeredPolls: [Int]? = []
                if let rawAnsweredPolls: String = data["answered polls"] as? String {
                    if rawAnsweredPolls.count > 0 {
                        answeredPolls = rawAnsweredPolls.components(separatedBy: ",").map({Int($0)!})
                    }
                }

                user.reconstruct(name: user.name, id: user.id, values: values, strengths: strengths, savedContent: savedContent, answeredPolls: answeredPolls, fromDatabase: true)
                callback?()

            }else {print("User document \(uid) does not exist")}
        }
    }

    public func updateUserProfile(_ user: CLPUser) {

        guard let uid = user.id else {return}
        let profileToUpload = user.toDict()
        if !profileToUpload.elementsEqual(lastUploadedProfile, by: { (newElement, uploadedElement) in
            let uploadedString = uploadedElement.value as! String
            return (newElement.key == uploadedElement.key) && (newElement.value == uploadedString)
        }) {
            Firestore.firestore().collection("Users").document(uid).setData(profileToUpload, mergeFields: user.listOfFullFields())
            lastUploadedProfile = profileToUpload
        }
        print("Did run Database.updateUserProfile()")
    }


    public func sendPollResults(_ poll: Poll, response: String) {
        if !poll.answers.contains(response) {fatalError("That's not a valid response to the poll. Aborting upload to database.")}
        Firestore.firestore().collection("Analytics").document("Polls").getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {

                var responseMap: [String : Int] = data[poll.question.noPeriods()] as! [String : Int]? ?? [:]
                let currentVotes: Int = responseMap[response.noPeriods()] ?? 0
                responseMap[response.noPeriods()] = currentVotes + 1

                Firestore.firestore().collection("Analytics").document("Polls").updateData([poll.question.noPeriods() : responseMap])

            }else {print("Polls document does not exist")}
        }

    }
}

extension String {
    func noPeriods() -> String {
        return self.replacingOccurrences(of: ".", with: "___")
    }

    func retrievePeriods() -> String {
        return self.replacingOccurrences(of: "___", with: ".")
    }
}
