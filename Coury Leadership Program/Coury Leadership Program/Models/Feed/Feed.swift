//
//  Feed.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation

public class Feed {
    //shared instance
    public private(set) static var shared: Feed = {
        return Feed()
    }()
    
    // As long as these are instantiated prior to a successfull fetch,
    // their local values will be set to the database values
    // (see Fetchable extensions)
    public let calendar = Calendar(documents: [])
    public let polls = Polls(documents: [])
    public let posts = Posts(documents: [])
    
    private var callbacks: [() -> Void] = []
    private var fetchStartTime: Date? = nil
    
    // private constructor
    private init() {
        Calendar.onFetchSuccess {self.checkFetchSuccess()}
        Polls.onFetchSuccess {self.checkFetchSuccess()}
        Posts.onFetchSuccess {self.checkFetchSuccess()}
    }
    
    public func startFetching() {
        fetchStartTime = Date()
        Calendar.startFetching()
        Polls.startFetching()
        Posts.startFetching()
    }
    
    public func stopFetching() {
        Calendar.stopFetching()
        Polls.stopFetching()
        Posts.stopFetching()
        fetchStartTime = nil
    }
    
    public func onFetchSuccess(callback: @escaping () -> Void)   {
        callbacks.append(callback)
    }
    
    public func clearFetchSuccessCallbacks() {
        callbacks = []
    }
    
    private func checkFetchSuccess() {
        let leastRecentModification = [calendar.lastModified, polls.lastModified, posts.lastModified].min()!
        if leastRecentModification > fetchStartTime! {
            callbacks.forEach({$0()})
        }
    }
}

extension Polls.Poll {
    var answered: Bool {
        return CLPProfile.shared.hasAnswered(self)
    }
}

extension Posts.Post {
    var liked: Bool {
        return CLPProfile.shared.hasLiked(self)
    }
}

extension Array where Element == Polls.Poll {
    var answered: [Element] {
        return self.filter({$0.answered})
    }
    var unanswered: [Element] {
        return self.filter({!$0.answered})
    }
}

extension Array where Element == Posts.Post {
    var liked: [Element] {
        return self.filter({$0.liked})
    }
}
