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
    
    private var signedIn: Bool
    private var lastUploadedProfile: [String : Any] = [:]
    private var storage: Storage
    
    /*
    private var signInStateChangeCallbacks: Dictionary<String, (Bool) -> Void> = [:]
    
    private var contentRetrievedCallbacks: Dictionary<String, ([FeedableData]) -> Void> = [:]
    private var calendarRetrievedCallbacks: Dictionary<String, (Calendar) -> Void> = [:]
    private var pollsRetrievedCallbacks: Dictionary<String, ([Poll]) -> Void> = [:]
    */
    
    
    
    // The shared instance
    private static var sharedDB: Database = {
        let db: Database = Database()
        return db
    }()
    
    // The constructor
    private init() {
        if let _ = Auth.auth().currentUser {
            signedIn = true
        } else {
            signedIn = false
        }
        storage = Storage.storage()
    }
    
    // Shared instance accessor
    public static func shared() -> Database {
        return sharedDB
    }
    
    // Modify sign-in state
    public func signIn() {
        signedIn = true
    }
    
    public func signOut() {
        signedIn = false
    }

    public private(set) var currentFeed = Feed(calendar: Calendar(events: []), polls: [], content: [])
    
    public func fetchContent(andRun callback: @escaping ([FeedableData]) -> Void) {
        
        Firestore.firestore().collection("Feed").document("Content").getDocument { (document, error) in
            
            if let document = document, document.exists {
                // Generate the appropriate FeedableData Items and send them to the callback
                var result: [FeedableData] = []
                
                guard let data = document.data() else {
                    // Could not find anything, so just return an empty array
                    print("Content document has no data")
                    callback(result)
                    return
                }
                
                guard let links: [String] = data["Links"] as? [String] else {
                    // Could not find links
                    print("Could not find links!")
                    callback(result)
                    return
                }
                for link in links {
                    let linkStruct: Link = Link(url: URL(string: link)!, squareImage: UIImage(color: .black)!)
                    result.append(linkStruct)
                }

                guard let images: [String] = data["Images"] as? [String] else {
                    // Could not find any images
                    print("Could not find images!")
                    callback(result)
                    return
                }
                for image in images {
                    let storageRef = self.storage.reference(withPath: "Feed/Images/" + image)
                    result.append(Image(imageReference: storageRef))
                }
                
                guard let quotes: [Dictionary<String, String>] = data["Quotes"] as? [Dictionary<String, String>] else {
                    // Could not find quotes
                    print("Could not finds quotes")
                    callback(result)
                    return
                }
                for quote in quotes {
                    let quoteStruct: Quote = Quote(quoteText: quote["text"]!, author: quote["author"]!)
                    result.append(quoteStruct)
                }

                self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: self.currentFeed.polls, content: result)
                callback(result)
                
            }else {
                // Could not find anything, so just return an empty array
                print("Content document does not exist")
                callback([])
                return
            }
            

        }
    }
    
    public func fetchCalendar(andRun callback: @escaping (Calendar) -> Void) {
        Firestore.firestore().collection("Feed").document("Calendar").getDocument { (document, error) in
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    // Could not find anything, so just return an empty array
                    print("Calendar document has no data")
                    callback(Calendar(events:[]))
                    return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d yyyy h:mma"
                var events: [CalendarEvent] = []
                
                for entry in data {
                    let dateString = (entry.value as! String)
                    if let date = dateFormatter.date(from: dateString) {
                        let calEvent: CalendarEvent = CalendarEvent(name: entry.key, date: date)
                        events.append(calEvent)
                    }else {
                        dateFormatter.dateFormat = "MMM d yyyy"
                        if let date = dateFormatter.date(from: dateString) {
                            let calEvent: CalendarEvent = CalendarEvent(name: entry.key, date: date)
                            events.append(calEvent)
                        }else {
                            dateFormatter.dateFormat = "MMM yyyy"
                            if let date = dateFormatter.date(from: dateString) {
                                let calEvent: CalendarEvent = CalendarEvent(name: entry.key, date: date)
                                events.append(calEvent)
                            }else {continue}
                        }
                    }
                }

                let sorted = events.sorted() {(event0, event1) -> Bool in
                    event0.date.compare(event1.date) == .orderedAscending
                }
                self.currentFeed = Feed(calendar: Calendar(events:sorted), polls: self.currentFeed.polls, content: self.currentFeed.content)
                callback(Calendar(events: sorted))

            }else {
                // Could not find anything, so just return an empty array
                print("Calendar document does not exist")
                callback(Calendar(events: []))
                return
            }
            
            
        }
    }
    
    public func fetchPolls(andRun callback: @escaping ([Poll]) -> Void) {
        Firestore.firestore().collection("Feed").document("Polls").getDocument { (document, error) in
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    // Could not find anything, so just return an empty array
                    print("Polls document has no data")
                    callback([])
                    return
                }
                
                var polls: [Poll] = []
                for (i, question) in data.enumerated() {
                    let answers = (question.value as! [String]).map({$0.retrievePeriods()})
                    polls.append(Poll(question: question.key.retrievePeriods(), answers: answers, id: i))
                }

                self.currentFeed = Feed(calendar: self.currentFeed.calendar, polls: polls, content: self.currentFeed.content)
                callback(polls)
                
            }else {
                // Could not find anything, so just return an empty array
                print("Polls document does not exist")
                callback([])
                return
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
