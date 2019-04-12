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

class Database {
    
    private var signedIn:Bool
    
    /*
    private var signInStateChangeCallbacks: Dictionary<String, (Bool) -> Void> = [:]
    
    private var contentRetrievedCallbacks: Dictionary<String, ([FeedableData]) -> Void> = [:]
    private var calendarRetrievedCallbacks: Dictionary<String, (Calendar) -> Void> = [:]
    private var pollsRetrievedCallbacks: Dictionary<String, ([Poll]) -> Void> = [:]
    */
    
    
    
    // The shared instance
    private static var sharedDB: Database = {
        let db:Database = Database()
        return db
    }()
    
    // The constructor
    private init() {
        if let _ = Auth.auth().currentUser {
            signedIn = true
        } else {
            signedIn = false
        }
        
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
    
    public func fetchContent(andRun callback: @escaping ([FeedableData]) -> Void) {
        
        Firestore.firestore().collection("Feed").document("Content").getDocument { (document, error) in
            
            if let document = document, document.exists {
                // Generate the appropriate FeedableData Items and send them to the callback
                var result:[FeedableData] = []
                
                guard let data = document.data() else {
                    // Could not find anything, so just return an empty array
                    print("Content document has no data")
                    callback(result)
                    return
                }
                
                guard let links:[String] = data["Links"] as? [String] else {
                    // Could not find links
                    print("Could not find links!")
                    callback(result)
                    return
                }
                for link in links {
                    let linkCell:Link = Link(url: URL(string: link)!, squareImage: UIImage(named:"first")!)
                    result.append(linkCell)
                }
                
                guard let quotes:[Dictionary<String, String>] = data["Quotes"] as? [Dictionary<String, String>] else {
                    // Could not find quotes
                    print("Could not finds quotes")
                    callback(result)
                    return
                }
                for quote in quotes {
                    let quoteCell:Quote = Quote(quoteText: quote["text"]!, author: quote["author"]!)
                    result.append(quoteCell)
                }
                
                callback(result)
                
            } else {
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
                dateFormatter.dateFormat = "MMM d h:mma"
                var events: [CalendarEvent] = []
                
                for entry in data {
                    let dateString = (entry.value as! String)
                    let date = dateFormatter.date(from: dateString)!
                    let calEvent:CalendarEvent = CalendarEvent(name: entry.key, date: date)
                    events.append(calEvent)
                }
                callback(Calendar(events: events))
                
            } else {
                // Could not find anything, so just return an empty array
                print("Calendar document does not exist")
                callback(Calendar(events:[]))
                return
            }
            
            
        }
    }
    
    public func fetchPolls(andRun callback: @escaping ([Poll]) -> Void) {
        callback([])
        // Will be changed with new database format by @adam later
    }
    
    public func uploadUserProfile(_ user: User) {
        // Temporary - real fix will be to store Firebase UID in User object
        if !signedIn {
            print("Error! user is not signed in")
            return
        }
        let uid:String = Auth.auth().currentUser!.uid
        var strengthStrings:[String] = []
        for strength in user.strengths {
            strengthStrings.append(strength.name)
        }
        
        Firestore.firestore().collection("Users").document(uid).setData([
            "name" : user.name,
            "strengths" : strengthStrings
        ]) { err in
            if let err = err {
                print("Error writing user document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
