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
    public private(set) var id: String? {
        didSet {if id != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    public private(set) var strengths: [String]? {
        didSet {if strengths != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    public private(set) var savedContent: [FeedableData]? {
        didSet {if savedContent != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }

    private static var sharedUser: CLPUser = {return CLPUser()}()
    private init() {
        if let googleUser = Auth.auth().currentUser {
            name = googleUser.displayName
            id = googleUser.uid
        }
    }
    public static func shared() -> CLPUser {return sharedUser}

    public func reconstruct(name: String?, id: String?, strengths: [String]?, savedContent: [FeedableData]?, fromDatabase: Bool = false) {
        isBulkUpdating = true
        self.name = name
        self.id = id
        self.strengths = strengths
        self.savedContent = savedContent
        isBulkUpdating = false
        if !fromDatabase {Database.shared().updateUserProfile(self)}
    }

    public func updateInformation(from googleUser: User) {
        self.name = googleUser.displayName
        self.id = googleUser.uid
    }

    public func makeAllNil() {
        self.name = nil
        self.id = nil
        self.strengths = nil
        self.savedContent = nil
    }

    public func set(strengths: [String]) {self.strengths = strengths}

    public func toDict() -> [String : String] {
        var dict: [String : String] = [:]

        dict["name"] = self.name != nil ? self.name : ""
        dict["id"] = self.id != nil ? self.id : ""
        dict["strengths"] = self.strengths != nil ? strengths!.joined(separator: ",") : ""
        dict["saved content"] = ""//TODO

        return dict
    }

    public func listOfFullFields() -> [String] {
        var fullFields: [String] = []

        if self.name != nil {fullFields.append("name")}
        if self.id != nil {fullFields.append("id")}
        if self.strengths != nil {fullFields.append("strengths")}
        if self.savedContent != nil {fullFields.append("saved content")}

        return fullFields
    }
}
