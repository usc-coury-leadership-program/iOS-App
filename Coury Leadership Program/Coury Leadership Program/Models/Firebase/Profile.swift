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

public struct CLPProfileData {
    let name: String?
    let uid: String?
    let values: [String]?
    let strengths: [String]?
    let savedContent: [String]?
    let answeredPolls: [String]?
    let goals: [[String]]?
    
//    func toDict() -> [String : String] {
//        var dict: [String : String] = [:]
//
//        dict["name"] = name ?? ""
//        dict["id"] = uid ?? ""
//        dict["values"] = values?.joined(separator: ",") ?? ""
//        dict["strengths"] = strengths?.joined(separator: ",") ?? ""
//        dict["saved content"] = savedContent?.map({String($0)}).joined(separator: ",") ?? ""
//        dict["answered polls"] = answeredPolls?.map({String($0)}).joined(separator: ",") ?? ""
//        dict["goals"] = goals?.map({$0.joined(separator: ",")}).joined(separator: ",") ?? ""
//
//        return dict
//    }
//
//    func listOfFullFields() -> [String] {
//        var fullFields: [String] = []
//
//        if name != nil {fullFields.append("name")}
//        if uid != nil {fullFields.append("id")}
//        if values != nil {fullFields.append("values")}
//        if strengths != nil {fullFields.append("strengths")}
//        if savedContent != nil {fullFields.append("saved content")}
//        if answeredPolls != nil {fullFields.append("answered polls")}
//        if goals != nil {fullFields.append("goals")}
//
//        return fullFields
//    }
}

public class CLPProfile {
    // shared instance
    public private(set) static var shared: CLPProfile = {
        return CLPProfile()
    }()
    
    public var isSigningIn = false
    
    private var hasData = false {didSet {self.checkFetchSuccess()}}
    private let dataClosure: (Timer) -> Void = {_ in Database.shared.fetchProfile()}
    private var dataProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: dataClosure)}
    private var activeProcesses: [Timer] = []
    private var codeToRunAfterFetching: [() -> Void] = []
    
    private var cachedServerData = CLPProfileData(name: nil, uid: nil, values: nil, strengths: nil, savedContent: nil, answeredPolls: nil, goals: nil)
    private var localData = CLPProfileData(name: nil, uid: nil, values: nil, strengths: nil, savedContent: nil, answeredPolls: nil, goals: nil) {
        didSet {flushDataToServer()}
    }
    
    public var name: String? {return Auth.auth().currentUser?.displayName}
    public var uid: String? {return Auth.auth().currentUser?.uid}
    public private(set) var values: [String]? {
        get {return localData.values ?? cachedServerData.values}
        set {localData = CLPProfileData(name: name, uid: uid, values: newValue, strengths: strengths, savedContent: savedContent, answeredPolls: answeredPolls, goals: goals)}
    }
    public private(set) var strengths: [String]? {
        get {return localData.strengths ?? cachedServerData.strengths}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: newValue, savedContent: savedContent, answeredPolls: answeredPolls, goals: goals)}
    }
    public private(set) var savedContent: [String]? {
        get {return localData.savedContent ?? cachedServerData.savedContent}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: strengths, savedContent: newValue, answeredPolls: answeredPolls, goals: goals)}
    }
    public private(set) var answeredPolls: [String]? {
        get {return localData.answeredPolls ?? cachedServerData.answeredPolls}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: strengths, savedContent: savedContent, answeredPolls: newValue, goals: goals)}
    }
    public private(set) var goals: [[String]]? {
        get {return localData.goals ?? cachedServerData.goals}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: strengths, savedContent: savedContent, answeredPolls: answeredPolls, goals: newValue)}
    }

    private init() {
        registerCallbacks()
    }
    
    public func flushDataToServer() {
        Database.shared.updateProfile(localData)
    }

    public func deleteLocalCopy() {
        localData = CLPProfileData(name: nil, uid: nil, values: nil, strengths: nil, savedContent: nil, answeredPolls: nil, goals: nil)
        cachedServerData = localData
    }

    public func set(values: [String]) {
        for value in values {
            Messaging.messaging().subscribe(toTopic: value) { error in
                print("Subscribed to \(value) notification topic")
            }
        }
        self.values = values
    }
    
    public func set(strengths: [String]) {
        for strength in strengths {
            Messaging.messaging().subscribe(toTopic: strength) { error in
                print("Subscribed to \(strength) notification topic")
            }
        }
        self.strengths = strengths
    }

    public func toggleSavedContent(for uid: String) {
        if savedContent == nil {
            savedContent = [uid]
        }else if let existingLocation = savedContent!.firstIndex(of: uid) {
            savedContent!.remove(at: existingLocation)
        }else {
            savedContent!.append(uid)
        }
    }
    
    public func toggleSavedContent(for item: TableableCellData) {
        let item = item as Any as! AnyHashable
        if savedContent == nil {
            savedContent = [Database.shared.runtimeHashDict[item.hashValue]!]
        }else if let existingLocation = savedContent!.firstIndex(of: Database.shared.runtimeHashDict[item.hashValue]!) {
            savedContent!.remove(at: existingLocation)
        }else {
            savedContent!.append(Database.shared.runtimeHashDict[item.hashValue]!)
        }
    }
    
    public func hasSavedContent(for index: Int) -> Bool {
        return savedContent?.contains(index) ?? false
    }
    
    public func hasSavedContent(for item: TableableCellData) -> Bool {
        let item = item as Any as! AnyHashable
        return savedContent?.contains(Database.shared.runtimeHashDict[item.hashValue] ?? -1) ?? false
    }

    public func addToAnsweredPolls(poll number: Int) {
        if answeredPolls == nil {answeredPolls = [number]}
        else if answeredPolls!.firstIndex(of: number) == nil {
            answeredPolls!.append(number)
        }
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
        hasData = false
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
        if (hasData) {
            stopFetching()
            for block in codeToRunAfterFetching {block()}
        }
    }
    
    private func registerCallbacks() {// TODO only set has___ to true if the result meets certain criteria?
        Database.shared.registerProfileCallback {(serverData) in
            self.cachedServerData = serverData
            self.hasData = true
        }
    }
}
