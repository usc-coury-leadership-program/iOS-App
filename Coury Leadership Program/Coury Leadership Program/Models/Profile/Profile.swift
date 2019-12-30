//
//  Profile.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class CLPProfile {
    //shared instance
    public private(set) static var shared: CLPProfile = {
        return CLPProfile()
    }()
    
    public var isSigningIn: Bool = false
    
    public var score: Int {
        return answeredPolls.polls.count + savedContent.posts.count + goals.goals.count
    }
    
    // As long as these are instantiated prior to a successfull fetch,
    // their local values will be set to the database values
    // (see Fetchable extensions)
    public let basicInformation = BasicInformation(strengths: [], values: [])
    public let answeredPolls = AnsweredPolls(polls: [])
    public let savedContent = SavedPosts(posts: [])
    public let goals = Goals(goals: [])
    
    private var callbacks: [() -> Void] = []
    private var fetchStartTime: Date? = nil
    
    // private constructor
    private init() {
        BasicInformation.onFetchSuccess {self.checkFetchSuccess()}
        AnsweredPolls.onFetchSuccess {self.checkFetchSuccess()}
        SavedPosts.onFetchSuccess {self.checkFetchSuccess()}
        Goals.onFetchSuccess {self.checkFetchSuccess()}
    }
    
    // MARK: BasicInformation
    public func has(value: Value) -> Bool {
        return basicInformation.values.contains(value.name)
    }
    public func set(values: [String], sync immediately: Bool = false) {
        basicInformation.values = values
        if immediately {basicInformation.startUploading()}
    }
    public func has(strength: Strength) -> Bool {
        return basicInformation.strengths.contains(strength.name)
    }
    public func set(strengths: [String], sync immediately: Bool = false) {
        basicInformation.strengths = strengths
        if immediately {basicInformation.startUploading()}
    }
    
    // MARK: Answered
    public func hasAnswered(_ poll: Polls.Poll) -> Bool {
        return answeredPolls.polls[poll.uid] != nil
    }
    public func answer(_ poll: Polls.Poll, sync immediately: Bool = false) {
        guard let selection = poll.selectedAnswer else {
            print("Profile.answer did fail. The referenced poll hasn't been answered yet")
            return
        }
        answeredPolls.polls[poll.uid] = AnsweredPolls.Poll(uid: poll.uid, selection: selection, timestamp: Timestamp())
        if immediately {answeredPolls.polls[poll.uid]!.startUploading()}
    }
    
    // MARK: Liked
    public func hasLiked(_ post: Posts.Post) -> Bool {
        return savedContent.posts[post.uid]?.status ?? false
    }
    public func like(_ post: Posts.Post, sync immediately: Bool = false) {
        savedContent.posts[post.uid] = SavedPosts.Post(uid: post.uid, status: true)
        if immediately {savedContent.posts[post.uid]!.startUploading()}
    }
    public func unlike(_ post: Posts.Post, sync immediately: Bool = false) {
        savedContent.posts[post.uid] = SavedPosts.Post(uid: post.uid, status: false)
        if immediately {savedContent.posts[post.uid]!.startUploading()}
    }
    public func toggleLike(_ post: Posts.Post, sync immediately: Bool = false) {
        hasLiked(post) ? unlike(post, sync: immediately) : like(post, sync: immediately)
    }
    
    // MARK: Goals
    // note that they're done differently (no dictionary) because an array must be available to the TableView that displays them, and it's nice if they stay in the same order
    public func hasAccomplished(_ goal: Goals.Goal) -> Bool {
        guard let i = goals.goals.map({$0.uid}).firstIndex(of: goal.uid) else {return false}
        return goals.goals[i].achieved
    }
    public func set(goal: Goals.Goal, sync immediately: Bool = false) {
        if let i = goals.goals.map({$0.uid}).firstIndex(of: goal.uid) {
            goals.goals[i] = goal
            if immediately {goals.goals[i].startUploading()}
        }else {
            goals.goals.append(goal)
            goals.goals.last!.startUploading()
        }
    }
    
    
    // MARK: Fetching
    public func startFetching() {
        fetchStartTime = Date()
        BasicInformation.startFetching()
        AnsweredPolls.startFetching()
        SavedPosts.startFetching()
        Goals.startFetching()
    }
    
    public func stopFetching() {
        BasicInformation.stopFetching()
        AnsweredPolls.stopFetching()
        SavedPosts.stopFetching()
        Goals.stopFetching()
        fetchStartTime = nil
    }
    
    public func onFetchSuccess(callback: @escaping () -> Void)   {
        callbacks.append(callback)
    }
    
    public func clearFetchSuccessCallbacks() {
        callbacks = []
    }
    
    private func checkFetchSuccess() {
        let leastRecentModification = [basicInformation.lastModified, answeredPolls.lastModified, savedContent.lastModified, goals.lastModified].min()!
        if leastRecentModification > fetchStartTime! {
            callbacks.forEach({$0()})
        }
    }
}

extension Array where Element == Goals.Goal {
    var unachieved: [Element] {
        return self.filter({!$0.achieved})
    }
}
