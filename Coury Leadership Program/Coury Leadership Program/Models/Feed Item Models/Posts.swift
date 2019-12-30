//
//  Posts.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Posts: TimestampedClass {
    private(set) var posts: [Post] {
        didSet {
            lastModified = Date()
        }
    }
    
    required public init(documents: [Post]) {
        self.posts = documents
        super.init()
        // Self.self is equivalent to Posts.self
        Database2.shared.register(Self.self) {self.checkFetchSuccess()}// gets called every fetch
        if !overwriteLocalWithDatabase() {
            Self.onFetchSuccess {self.overwriteLocalWithDatabase()}// gets called first fetch
        }
    }
}

extension Posts: Fetchable2 {
    public static let queryPath: String = "FeedContent"
    public static let queryOrderField: String? = "timestamp"
    public static let queryShouldDescend: Bool? = true
    
    public var localValue: Posts {
        get {return self}
        set {posts = newValue.posts}
    }
    
    public static var callbacks: [() -> Void] = []
    public static var process: Timer? = nil
}

extension Posts: Hashable {
    public static func == (lhs: Posts, rhs: Posts) -> Bool {
        return lhs.posts == rhs.posts
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(posts)
    }
}


extension Posts {
    public class Post: DBDocumentParser, TableableCellData, Hashable {
        public let CorrespondingView: TableableCell.Type
        
        public let uid: String
        
        init(correspondingView: TableableCell.Type, uid: String) {
            CorrespondingView = correspondingView
            self.uid = uid
        }
        
        public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
            let data = dbDocument.data()!

            switch data["type"] as? String {
            case "Quote": return Posts.Quote(dbDocument: dbDocument)
            case "Link": return Posts.Link(dbDocument: dbDocument)
            case "Image": return Posts.Image(dbDocument: dbDocument)
            default: fatalError("\(String(describing: data["type"])) is not a valid Post type")
            }
        }
        
        // MARK: Hashable
        public static func == (lhs: Posts.Post, rhs: Posts.Post) -> Bool {
            return lhs.uid == rhs.uid
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }
    }
}
