//
//  Posts.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Posts: HashableTypeSeed {
    private(set) var posts: [Post]
    
    required public init(documents: [Post]) {
        super.init()
        self.posts = documents
    }
}

extension Posts: Fetchable2 {
    public static let queryPath: String = "FeedContent"
    public static let queryOrderField: String = "timestamp"
    public static let queryShouldDescend: Bool = true
    
    public var localValue: Posts {
        get {return self}
        set {posts = newValue.posts}
    }
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
    public class Post: Hashable, QueryDocumentConverter, ContentCellData {
        public let CorrespondingView: TableableCell.Type
        
        public let uid: String
        public var shouldDisplay: Bool {return CLPProfile.shared.has(savedContent: uid)}
        
        init(correspondingView: TableableCell.Type, uid: String) {
            CorrespondingView = correspondingView
            self.uid = uid
        }
        public required init(dbDocument: QueryDocumentSnapshot) {
            fatalError("Posts is essentially an abstract class; this initializaer has not been implemented.")
        }
        
        public static func createPost(from dbDocument: QueryDocumentSnapshot) -> Post {
            let data = dbDocument.data()
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
