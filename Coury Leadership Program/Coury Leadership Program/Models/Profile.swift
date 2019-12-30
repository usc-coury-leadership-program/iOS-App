//
//  Profile.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation

public class CLPProfile {
    //shared instance
    public private(set) static var shared: CLPProfile = {
        return CLPProfile()
    }()
    
    public var isSigningIn: Bool = false
    
    // As long as these are instantiated prior to a successfull fetch,
    // their local values will be set to the database values
    // (see Fetchable extensions)
    public let basicInformation = BasicInformation(strengths: [], values: [])
    public let answeredPolls = AnsweredPolls(answeredPolls: [])
    public let savedContent = SavedContent(savedPosts: [])
    public let goals = Goals(goals: [])
    
    private var callbacks: [() -> Void] = []
    private var fetchStartTime: Date? = nil
    
    // private constructor
    private init() {
        BasicInformation.onFetchSuccess {self.checkFetchSuccess()}
        AnsweredPolls.onFetchSuccess {self.checkFetchSuccess()}
        SavedContent.onFetchSuccess {self.checkFetchSuccess()}
        Goals.onFetchSuccess {self.checkFetchSuccess()}
    }
    
    // MARK: Set functions
    public func set(values: [String]) {basicInformation.values = values}
    public func set(strengths: [String]) {basicInformation.strengths = strengths}
    public func set(answeredPolls: [AnsweredPolls.AnsweredPoll]) {self.answeredPolls.answeredPolls = answeredPolls}
    public func set(answeredPollsUIDs: [String]) {self.set(answeredPolls: answeredPollsUIDs.map({AnsweredPolls.AnsweredPoll($0)}))}
    public func set(savedPosts: [SavedContent.SavedPost]) {self.savedContent.savedPosts = savedPosts}
    public func set(savedPostsUIDs: [String]) {self.set(savedPosts: savedPostsUIDs.map({SavedContent.SavedPost($0)}))}
    public func set(goals: [Goals.Goal]) {self.goals.goals = goals}
    
    public func like(_ post: Posts.Post) {
        //TODO
//        savedContent.savedPosts.map({$0.uid}).
    }
    
    public func answer(_ poll: Polls.Poll) {
        
    }
    
    

//    // MARK: Add functions
//    public func add(answeredPoll uid: String) {
//        if answeredPolls == nil {answeredPolls = [uid]}
//        else {answeredPolls!.append(uid)}
//    }
//    public func add(goal: Goal) {
//        if goals == nil {goals = [goal]}
//        else {goals!.append(goal)}
//    }
//
//    // MARK: Toggle functions
//    public func toggle(savedContent uid: String) {
//        if savedContent == nil {
//            savedContent = [uid]
//        }else if let existingLocation = savedContent!.firstIndex(of: uid) {
//            savedContent!.remove(at: existingLocation)
//        }else {
//            savedContent!.append(uid)
//        }
//    }
//
//    // MARK: remove functions
//    public func remove(goal: Goal) {
//        goals?.remove(at: (goals?.firstIndex(where: {$0.uid == goal.uid}))!)
//    }
//    public func remove(goalAt index: Int) {
//        goals?.remove(at: index)
//    }
    
    public func startFetching() {
        fetchStartTime = Date()
        BasicInformation.startFetching()
        AnsweredPolls.startFetching()
        SavedContent.startFetching()
        Goals.startFetching()
    }
    
    public func stopFetching() {
        BasicInformation.stopFetching()
        AnsweredPolls.stopFetching()
        SavedContent.stopFetching()
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
        print("Profile checking fetch success")
        print([basicInformation.lastModified, answeredPolls.lastModified, savedContent.lastModified, goals.lastModified].map({$0.compare(fetchStartTime!)}))
        let leastRecentModification = [basicInformation.lastModified, answeredPolls.lastModified, savedContent.lastModified, goals.lastModified].min()!
        if leastRecentModification > fetchStartTime! {
            callbacks.forEach({$0()})
        }
    }
}
