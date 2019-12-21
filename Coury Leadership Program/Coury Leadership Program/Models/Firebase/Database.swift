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
    private let db = Firestore.firestore()
    
    private var calendarGotSetCallbacks: [() -> Void] = []
    private var pollsGotSetCallbacks: [() -> Void] = []
    private var contentGotSetCallbacks: [() -> Void] = []
    private var profileGotSetCallbacks: [() -> Void] = []
    // public instance properties
    public private(set) var calendar: Calendar = Calendar(events: []) {
        didSet {for callback in calendarGotSetCallbacks {callback()}}
    }
    public private(set) var polls: [TableableCellData] = [] {
        didSet {for callback in pollsGotSetCallbacks {callback()}}
    }
    public private(set) var content: [ContentCellData] = [] {
        didSet {for callback in contentGotSetCallbacks {callback()}}
    }

    // private constructor
    private init() {}

    public func registerCalendarCallback(_ callback: @escaping () -> Void) {
        calendarGotSetCallbacks.append(callback)
    }
    public func registerPollsCallback(_ callback: @escaping () -> Void) {
        pollsGotSetCallbacks.append(callback)
    }
    public func registerContentCallback(_ callback: @escaping () -> Void) {
        contentGotSetCallbacks.append(callback)
    }
    public func registerProfileCallback(_ callback: @escaping () -> Void) {
        profileGotSetCallbacks.append(callback)
    }

    public func clearCallbacks() {
        print("Clearing Database callbacks")
        calendarGotSetCallbacks = []
        pollsGotSetCallbacks = []
        contentGotSetCallbacks = []
        profileGotSetCallbacks = []
    }
    
    public func fetchCalendar() {
        db.collection("Calendar").getDocuments() { (snapshot, error) in
            if let snapshot = snapshot {
                
                var events: [Calendar.Event] = []
                
                for document in snapshot.documents {
                    // each document should represent an event
                    let uid = document.documentID
                    let event = document.data()
                    
                    var name: String = ""
                    var startTime: Timestamp = Timestamp()
                    var endTime: Timestamp?
                    var location: String?
                    
                    for entry in event {
                        switch entry.key {
                        case "name":
                            name = entry.value as! String
                        case "start_time":
                            startTime = entry.value as! Timestamp
                        case "end_time":
                            endTime = entry.value as? Timestamp
                        case location:
                            location = entry.value as? String
                        default:
                            break
                        }
                    }
                    events.append(Calendar.Event(name: name, start: startTime.dateValue(), end: endTime?.dateValue(), location: location, uid: uid))
                }
                
                let sorted = events.sorted() {(event0, event1) -> Bool in
                    event0.start.compare(event1.start) == .orderedAscending
                }
                self.calendar = Calendar(events: sorted)
            }
        }
    }
    
    public func fetchPolls() {
        db.collection("Polls").getDocuments() { (snapshot, error) in
            if let snapshot = snapshot {
                
                var polls: [(Date, Poll)] = []
                
                for document in snapshot.documents {
                    // each document should represent a poll
                    let uid = document.documentID
                    let poll = document.data()
                    
                    var title: String = ""
                    var timestamp: Timestamp = Timestamp()
                    var options: [String] = []
                    
                    for entry in poll {
                        switch entry.key {
                        case "title":
                            title = entry.value as! String
                        case "timestamp":
                            timestamp = entry.value as! Timestamp
                        case "Options":
                            let option_arr = entry.value as! [[String : Int]]
                            options = option_arr.map({$0.keys.first!})
                        default:
                            break
                        }
                    }
                    polls.append((timestamp.dateValue(), Poll(question: title, answers: options, uid: uid)))
                }
                
                let sorted = polls.sorted() {(poll0, poll1) -> Bool in
                    poll0.0.compare(poll1.0) == .orderedAscending
                }
                self.polls = sorted.map({$0.1})
            }
        }
    }

    public func fetchContent() {
        
    }
    
    public func fetchProfile() {
        if let googleUser = Auth.auth().currentUser {
            let name = googleUser.displayName
            let uid = googleUser.uid
            
            let userDoc = db.collection("Users").document(uid)
            userDoc.getDocument { (document, error) in
                if let error = error {print("Failed to get user document: \(error)")}
                if let document = document, document.exists, let profile = document.data() {
                    
                    for entry in profile {
                        switch entry.key {
                        case "strengths":
                            CLPProfile.shared.set(strengths: entry.value as! [String])
                        case "values":
                            CLPProfile.shared.set(values: entry.value as! [String])
                        default: break
                        }
                    }
                }
                for callback in self.profileGotSetCallbacks {callback()}
            }
            userDoc.collection("AnsweredPolls").getDocuments { (snapshot, error) in
                if let error = error {print("Failed to get user's AnsweredPolls collection: \(error)")}
                if let snapshot = snapshot {
                    CLPProfile.shared.set(answeredPolls: snapshot.documents.map({$0.documentID}))
                }
                for callback in self.profileGotSetCallbacks {callback()}
            }
            userDoc.collection("SavedContent").getDocuments { (snapshot, error) in
                if let error = error {print("Failed to get user's SavedContent collection: \(error)")}
                if let snapshot = snapshot {
                    CLPProfile.shared.set(savedContent: snapshot.documents.map({$0.documentID}))
                }
                for callback in self.profileGotSetCallbacks {callback()}
            }
        }
    }

//    public func updateProfile(_ profile: CLPProfileData) {
//
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let profileToUpload = profile.toDict()
//        if !profileToUpload.elementsEqual(lastUploadedProfile, by: { (newElement, uploadedElement) in
//            let uploadedString = uploadedElement.value as! String
//            return (newElement.key == uploadedElement.key) && (newElement.value == uploadedString)
//        }) {
//            db.collection("Users").document(uid).setData(profileToUpload, mergeFields: profile.listOfFullFields())
//            lastUploadedProfile = profileToUpload
//        }
//        print("Did run Database.updateUserProfile()")
//    }
    
    public func sendPollResponse(_ poll: Poll, choice: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let pollDoc = db.collection("Polls").document(poll.uid)
        
        let responseDoc = pollDoc.collection("Responses").document(uid)
        responseDoc.setData([
            "choice": choice,
            "timestamp": Timestamp(date: Date(timeIntervalSinceNow: 0.0))
        ], merge: true)
        
        pollDoc.getDocument() { (docSnapshot, error) in
            if let error = error {
                print("Failed to get poll \(poll.uid): \(error)")
                return
            }
            guard let data = docSnapshot?.data() else {
                print("Data from poll \(poll.uid) was nil")
                return
            }
            
            var options: [[String : Int]] = data["Options"] as! [[String : Int]]
            let responses = options[choice].first!
            // NOTE: adding 1 here means that users could potentially vote more than once
            // Thus, we're relying on the UI to hide it from them
            options[choice] = [responses.key : responses.value + 1]
            
            pollDoc.setData([
                "Options": options
            ], merge: true)
        }
    }
}

extension String {
    func noPeriods() -> String {return self.replacingOccurrences(of: ".", with: "___")}
    func retrievePeriods() -> String {return self.replacingOccurrences(of: "___", with: ".")}
}
