//
//  User.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

public class CLPUser {

    public var isSigningIn: Bool = false
    private var isBulkUpdating: Bool = false

    public private(set) var name: String? {
        didSet {if name != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    public private(set) var uid: String? {
        didSet {if uid != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    public private(set) var strengths: [Strength]? {
        didSet {if strengths != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    public private(set) var savedContent: [FeedableData]? {
        didSet {if savedContent != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }

    private static var sharedUser: CLPUser = {return CLPUser()}()
    private init() {
        if let googleUser = Auth.auth().currentUser {
            name = googleUser.displayName
            uid = googleUser.uid
        }
    }
    public static func shared() -> CLPUser {return sharedUser}

    public func reconstruct(name: String?, uid: String?, strengths: [Strength]?, savedContent: [FeedableData]?) {
        isBulkUpdating = true
        self.name = name
        self.uid = uid
        self.strengths = strengths
        self.savedContent = savedContent
        isBulkUpdating = false
        Database.shared().updateUserProfile(self)
    }

    public func updateInformation(from googleUser: User) {
        self.name = googleUser.displayName
        self.uid = googleUser.uid
    }

    public func makeAllNil() {
        self.name = nil
        self.uid = nil
        self.strengths = nil
        self.savedContent = nil
    }

    public func set(strengths: [Strength]) {self.strengths = strengths}

    public func toDict() -> [String : String] {
        var dict: [String : String] = [:]

        dict["name"] = self.name != nil ? self.name : ""
        dict["uid"] = self.uid != nil ? self.uid : ""
        dict["strengths"] = self.strengths != nil ? strengthsAsStrings().joined(separator: ",") : ""
        dict["saved content"] = ""//TODO

        return dict
    }

    public func listOfFullFields() -> [String] {
        var fullFields: [String] = []

        if self.name != nil {fullFields.append("name")}
        if self.uid != nil {fullFields.append("uid")}
        if self.strengths != nil {fullFields.append("strengths")}
        if self.savedContent != nil {fullFields.append("saved content")}

        return fullFields
    }

    public func strengthsAsStrings() -> [String] {
        guard let strengths = self.strengths else {return []}
        return strengths.map() {$0.name}
    }
}
