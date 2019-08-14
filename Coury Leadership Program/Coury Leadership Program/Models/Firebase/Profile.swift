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
    let savedContent: [Int]?
    let answeredPolls: [Int]?
    
    func toDict() -> [String : String] {
        var dict: [String : String] = [:]
        
        dict["name"] = name ?? ""
        dict["id"] = uid ?? ""
        dict["values"] = values?.joined(separator: ",") ?? ""
        dict["strengths"] = strengths?.joined(separator: ",") ?? ""
        dict["saved content"] = savedContent?.map({String($0)}).joined(separator: ",") ?? ""
        dict["answered polls"] = answeredPolls?.map({String($0)}).joined(separator: ",") ?? ""
        
        return dict
    }
    
    func listOfFullFields() -> [String] {
        var fullFields: [String] = []
        
        if name != nil {fullFields.append("name")}
        if uid != nil {fullFields.append("id")}
        if values != nil {fullFields.append("values")}
        if strengths != nil {fullFields.append("strengths")}
        if savedContent != nil {fullFields.append("saved content")}
        if answeredPolls != nil {fullFields.append("answered polls")}
        
        return fullFields
    }
}

public class CLPProfile {
    // shared instance
    public private(set) static var shared: CLPProfile = {
        return CLPProfile()
    }()
    
    private var hasData = false {didSet {self.checkFetchSuccess()}}
    private let dataClosure: (Timer) -> Void = {_ in Database.shared.fetchProfile()}
    private var dataProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: dataClosure)}
    private var activeProcesses: [Timer] = []
    private var codeToRunAfterFetching: [() -> Void] = []
    
    private var serverData = CLPProfileData(name: nil, uid: nil, values: nil, strengths: nil, savedContent: nil, answeredPolls: nil)
    private var localData = CLPProfileData(name: nil, uid: nil, values: nil, strengths: nil, savedContent: nil, answeredPolls: nil) {
        didSet {Database.shared.updateProfile(localData)}
    }
    
    public var name: String? {return Auth.auth().currentUser?.displayName}
    public var uid: String? {return Auth.auth().currentUser?.uid}
    public private(set) var values: [String]? {
        get {return localData.values ?? serverData.values}
        set {localData = CLPProfileData(name: name, uid: uid, values: newValue, strengths: strengths, savedContent: savedContent, answeredPolls: answeredPolls)}
    }
    public private(set) var strengths: [String]? {
        get {return localData.strengths ?? serverData.strengths}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: newValue, savedContent: savedContent, answeredPolls: answeredPolls)}
    }
    public private(set) var savedContent: [Int]? {
        get {return localData.savedContent ?? serverData.savedContent}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: strengths, savedContent: newValue, answeredPolls: answeredPolls)}
    }
    public private(set) var answeredPolls: [Int]? {
        get {return localData.answeredPolls ?? serverData.answeredPolls}
        set {localData = CLPProfileData(name: name, uid: uid, values: values, strengths: strengths, savedContent: savedContent, answeredPolls: newValue)}
    }

    private init() {
        registerCallbacks()
    }

    public func deleteLocalCopy() {
        localData = CLPProfileData(name: nil, uid: nil, values: nil, strengths: nil, savedContent: nil, answeredPolls: nil)
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

    public func toggleSavedContent(for index: Int) {
        if savedContent == nil {
            savedContent = [index]
        }else if let existingLocation = savedContent!.firstIndex(of: index) {
            savedContent!.remove(at: existingLocation)
        }else {
            savedContent!.append(index)
        }
    }

    public func addToAnsweredPolls(poll number: Int) {
        if answeredPolls == nil {answeredPolls = [number]}
        else if answeredPolls!.firstIndex(of: number) == nil {
            answeredPolls?.append(number)
        }
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
            self.serverData = serverData
            self.hasData = true
        }
    }
}
