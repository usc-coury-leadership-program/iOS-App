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
    public var posts: [String : Post] {
        didSet {
            lastModified = Date()
        }
    }
    
    public init(posts: [Post]) {
        self.posts = posts.reduce(into: [String : Post]()) {
            $0[$1.uid] = $1
        }
        super.init()
        // Self.self is equivalent to SavedContent.self
        Database2.shared.register(Self.self) {self.checkFetchSuccess()}// gets called every fetch
        if !overwriteLocalWithDatabase() {
            Self.onFetchSuccess {self.overwriteLocalWithDatabase()}// gets called first fetch
        }
    }
    
    public required convenience init(documents: [Post]) {
        self.init(posts: documents)
    }
}

extension SavedContent: Fetchable2 {
    public static var queryPath: String {return "Users/{UserID}/SavedContent"}
    public static let queryOrderField: String? = nil
    public static let queryShouldDescend: Bool? = nil
    
    public var localValue: SavedContent {
        get {return self}
        set {posts = newValue.posts}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var process: Timer? = nil
}

extension SavedContent: Hashable {
    public static func == (lhs: SavedContent, rhs: SavedContent) -> Bool {
        return lhs.posts == rhs.posts
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(posts)
    }
}

extension SavedContent {
    public struct Post: DBDocumentParser, Uploadable, Hashable {
        public let uid: String
        public let status: Bool
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            return Post(uid: dbDocument.documentID, status: dbDocument.data()!["status"] as! Bool)
        }
        
        public var uploadPath: String {return "Users/{UserID}/SavedContent/\(uid)"}
        
        public func inject(into dbDocument: DocumentReference) {
            dbDocument.setData([
                "status": status
            ])
        }
    }
}
