//
//  Profile.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

public class CLPProfile {
    // shared instance
    public private(set) static var shared: CLPProfile = {
        return CLPProfile()
    }()
    
    public var isSigningIn = false
    
    // private instance propertoes
    private var hasStrengthsAndValues = false {didSet {self.checkFetchSuccess()}}
    private var hasAnsweredPolls = false {didSet {self.checkFetchSuccess()}}
    private var hasSavedContent = false {didSet {self.checkFetchSuccess()}}
    private var hasGoals = false {didSet {self.checkFetchSuccess()}}
    
    private let strengthsAndValuesClosure: (Timer) -> Void = {_ in Database.shared.fetchStrengthsAndValues(userDoc: Database.db.collection("Users").document(uid))}
    private let pollsClosure: (Timer) -> Void = {_ in Database.shared.fetchPolls()}
    private let contentClosure: (Timer) -> Void = {_ in Database.shared.fetchContent()}
    
    private let dataClosure: (Timer) -> Void = {_ in Database.shared.fetchProfile()}
    private var dataProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: dataClosure)}
    private var activeProcesses: [Timer] = []
    private var codeToRunAfterFetching: [() -> Void] = []
    
    public var name: String? {return Auth.auth().currentUser?.displayName}
    public var uid: String? {return Auth.auth().currentUser?.uid}
    public private(set) var values: [String]?
    public private(set) var strengths: [String]?
    public private(set) var savedContent: [String]?
    public private(set) var answeredPolls: [String]? {
        didSet {for callback in codeToRunAfterAnsweringPoll {callback()}}
    }
    public private(set) var goals: [Goal]?
    
    private var codeToRunAfterAnsweringPoll: [() -> Void] = []

    private init() {
        registerCallbacks()
    }
    
    public func flushDataToServer() {
        if strengths != nil {
            for strength in strengths! {
                Messaging.messaging().subscribe(toTopic: strength.replacingOccurrences(of: " ", with: "-")) { error in
                    print("Subscribed to \(strength) notification topic")
                }
            }
        }
        if values != nil {
            for value in values! {
                Messaging.messaging().subscribe(toTopic: value.replacingOccurrences(of: " ", with: "-")) { error in
                    print("Subscribed to \(value) notification topic")
                }
            }
        }
        
        Database.shared.upload(profile: self)
    }

    public func deleteLocalCopy() {
        values = nil
        strengths = nil
        savedContent = nil
        answeredPolls = nil
        goals = nil
    }
    
    public func onAnswerPoll(run block: @escaping () -> Void) {
        codeToRunAfterAnsweringPoll.append(block)
    }
    public func clearAnswerPollCallbacks() {
        codeToRunAfterAnsweringPoll = []
    }
    
    // MARK: Set functions
    public func set(values: [String]) {self.values = values}
    public func set(strengths: [String]) {self.strengths = strengths}
    public func set(savedContent: [String]) {self.savedContent = savedContent}
    public func set(answeredPolls: [String]) {self.answeredPolls = answeredPolls}
    public func set(goals: [Goal]) {self.goals = goals}
    
    // MARK: Add functions
    public func add(answeredPoll uid: String) {
        if answeredPolls == nil {answeredPolls = [uid]}
        else {answeredPolls!.append(uid)}
    }
    public func add(goal: Goal) {
        if goals == nil {goals = [goal]}
        else {goals!.append(goal)}
    }
    
    // MARK: Toggle functions
    public func toggle(savedContent uid: String) {
        if savedContent == nil {
            savedContent = [uid]
        }else if let existingLocation = savedContent!.firstIndex(of: uid) {
            savedContent!.remove(at: existingLocation)
        }else {
            savedContent!.append(uid)
        }
    }
    
    // MARK: remove functions
    public func remove(goal: Goal) {
        goals?.remove(at: (goals?.firstIndex(where: {$0.uid == goal.uid}))!)
    }
    public func remove(goalAt index: Int) {
        goals?.remove(at: index)
    }
    
    // MARK: Read functions
    public func has(savedContent uid: String) -> Bool {
        return savedContent?.contains(uid) ?? false
    }
    public func has(answeredPoll uid: String) -> Bool {
        return answeredPolls?.contains(uid) ?? false
    }
}


extension CLPProfile: Fetchable {
    
    private func resetState() {
        hasData = 0
    }
    
    public func ensureExistence() {
        if hasData < 4 {beginFetching()}
    }
    
    public func beginFetching() {
        resetState()
        activeProcesses += [dataProcess]
        for process in activeProcesses {RunLoop.current.add(process, forMode: .common)}
    }
    
    public func isFetching() -> Bool {
        return activeProcesses.count > 0
    }
    
    public func stopFetching() {
        for process in activeProcesses {process.invalidate()}
        activeProcesses = []
    }
    
    public func onFetchSuccess(run block: @escaping () -> Void) {
        codeToRunAfterFetching.append(block)
    }
    
    public func clearFetchSuccessCallbacks() {
        codeToRunAfterFetching = []
    }
    
    private func checkFetchSuccess() {
        if (hasData >= 4) {
            stopFetching()
            for block in codeToRunAfterFetching {block()}
        }
    }
    
    private func registerCallbacks() {// TODO only set has___ to true if the result meets certain criteria?
        Database.shared.registerProfileCallback {
            self.hasData += 1
        }
    }
}
