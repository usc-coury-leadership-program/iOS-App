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

//public struct User {
//
//    let strengths: [Strength]
//    let savedContent: [FeedableData]
//
//}

public class User {

    private var isBulkUpdating: Bool = false

    private var name: String? {
        didSet {if name != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    private var uid: String? {
        didSet {if uid != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    private var strengths: [Strength]? {
        didSet {if strengths != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }
    private var savedContent: [FeedableData]? {
        didSet {if savedContent != nil && !isBulkUpdating {Database.shared().updateUserProfile(self)}}
    }

    private static var sharedUser: User = {return User()}()
    private init() {
        if let googleUser = Auth.auth().currentUser {
            name = googleUser.displayName
            uid = googleUser.uid
        }
    }
    public static func shared() -> User {return sharedUser}

    public func reconstruct(name: String?, uid: String?, strengths: [Strength]?, savedContent: [FeedableData]?) {
        isBulkUpdating = true
        self.name = name
        self.uid = uid
        self.strengths = strengths
        self.savedContent = savedContent
        isBulkUpdating = false
        Database.shared().uploadUserProfile(self)
    }
}
