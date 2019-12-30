//
//  SavedContent.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class SavedContent: TimestampedClass {
    private(set) var savedPosts: [SavedPost] {
        didSet {
            lastModified = Date()
        }
    }
    
    public init(savedPosts: [SavedPost]) {
        self.savedPosts = savedPosts
        super.init()
    }
    
    public required convenience init(documents: [SavedPost]) {
        self.init(savedPosts: documents)
        // Self.self is equivalent to SavedContent.self
        Database2.shared.register(Self.self) {self.checkFetchSuccess()}
    }
}

extension SavedContent: Fetchable2 {
    public static var queryPath: String {return "Users/{UserID}/SavedContent"}
    public static let queryOrderField: String? = nil
    public static let queryShouldDescend: Bool? = nil
    
    public var localValue: SavedContent {
        get {return self}
        set {savedPosts = newValue.savedPosts}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var activeProcesses: [Timer] = []
}

extension SavedContent: Hashable {
    public static func == (lhs: SavedContent, rhs: SavedContent) -> Bool {
        return lhs.savedPosts == rhs.savedPosts
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(savedPosts)
    }
}

extension SavedContent {
    public struct SavedPost: DBDocumentParser, Uploadable, Hashable {
        public let uid: String
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            return SavedPost(uid: dbDocument.documentID)
        }
        
        public var uploadPath: String {return "Users/{UserID}/SavedContent/\(uid)"}
        
        public func inject(into dbDocument: DocumentReference) {
            dbDocument.setData([
                "Status": true
            ])
        }
    }
}
