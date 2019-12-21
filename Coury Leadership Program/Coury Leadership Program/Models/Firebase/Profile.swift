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
    
    private var hasData = 0 {didSet {self.checkFetchSuccess()}}
    private let dataClosure: (Timer) -> Void = {_ in Database.shared.fetchProfile()}
    private var dataProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: dataClosure)}
    private var activeProcesses: [Timer] = []
    private var codeToRunAfterFetching: [() -> Void] = []
    
    public var name: String? {return Auth.auth().currentUser?.displayName}
    public var uid: String? {return Auth.auth().currentUser?.uid}
    public private(set) var values: [String]?
    public private(set) var strengths: [String]?
    public private(set) var savedContent: [String]?
    public private(set) var answeredPolls: [String]?
    public private(set) var goals: [[String]]?

    private init() {
        registerCallbacks()
    }
    
    public func flushDataToServer() {
        if strengths != nil {
            for strength in strengths! {
                Messaging.messaging().subscribe(toTopic: strength) { error in
                    print("Subscribed to \(strength) notification topic")
                }
            }
        }
        if values != nil {
            for value in values! {
                Messaging.messaging().subscribe(toTopic: value) { error in
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
    
    // MARK: Set functions
    public func set(values: [String]) {self.values = values}
    public func set(strengths: [String]) {self.strengths = strengths}
    public func set(savedContent: [String]) {self.savedContent = savedContent}
    public func set(answeredPolls: [String]) {self.answeredPolls = answeredPolls}
    
    // MARK: Add functions
    public func add(answeredPoll uid: String) {
        if answeredPolls == nil {answeredPolls = [uid]}
        else {answeredPolls!.append(uid)}
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
    
    // MARK: Read functions
    public func has(savedContent uid: String) -> Bool {
        return savedContent?.contains(uid) ?? false
    }
    public func has(answeredPoll uid: String) -> Bool {
        return answeredPolls?.contains(uid) ?? false
    }
    
    public func addNew(goal: Goal) {
        
        let strengthString = String(STRENGTH_LIST.firstIndex(where: {$0.name == goal.strength?.name ?? ""}) ?? -1)
        let valueString = String(VALUE_LIST.firstIndex(where: {$0.name == goal.value?.name ?? ""}) ?? -1)
        let goalAsArray = [goal.text, strengthString, valueString]
        if goals == nil {goals = [goalAsArray]}
        else {
            goals!.append(goalAsArray)
        }
    }
    
    public func removeGoal(at index: Int) {
        if goals == nil || index > goals!.count {return}
        goals!.remove(at: index)
    }
    
    public func goal(at index: Int) -> Goal {
        guard let rawGoal = goals?[index] else {return Goal(text: "", strength: nil, value: nil)}
        let text = rawGoal[0]
        let strengthIndex = Int(rawGoal[1])
        let strength: Strength? = strengthIndex == -1 ? nil : STRENGTH_LIST[strengthIndex!]
        let valueIndex = Int(rawGoal[2])
        let value: Value? = valueIndex == -1 ? nil : VALUE_LIST[valueIndex!]
        
        return Goal(text: text, strength: strength, value: value)
    }
}


extension CLPProfile: Fetchable {
    
    private func resetState() {
        hasData = 0
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
        if (hasData >= 3) {
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
