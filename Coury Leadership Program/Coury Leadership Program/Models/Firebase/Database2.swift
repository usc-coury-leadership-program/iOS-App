//
//  Database2.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class Database2 {
    //shared instance
    public private(set) static var shared: Database2 = {
        return Database2()
    }()
    
    public static let storage = Storage.storage()
    public static let db = Firestore.firestore()
    
    private var callbacks: [Int : [() -> Void]] = [:]
    public private(set) var data: [Int : TimestampedClass] = [:]
    
    // private constructor
    private init() {}
    
    public func register<T: Fetchable2>(_ item: T.Type, callback: @escaping () -> Void) {
        let hash = HashableType<T.CollectionEquivalent>(T.CollectionEquivalent.self).hashValue
        callbacks[hash] = (callbacks[hash] ?? []) + [callback]
    }
    
    public func clearCallbacks() {
        callbacks = [:]
    }
    public func clearCallbacks<T: Fetchable2>(_ item: T.Type) {
        let hash = HashableType<T.CollectionEquivalent>(T.CollectionEquivalent.self).hashValue
        callbacks[hash] = []
    }
    
    private func save<T: Fetchable2>(_ item: T) {
        let hash = HashableType<T.CollectionEquivalent>(T.CollectionEquivalent.self).hashValue
        data[hash] = item.localValue
        callbacks[hash]?.forEach({$0()})
//        clearCallbacks(T.self)
    }
    
    public func read<T: Fetchable2>(_ item: T.Type) -> T.CollectionEquivalent? {
        let hash = HashableType<T.CollectionEquivalent>(T.CollectionEquivalent.self).hashValue
        return data[hash] as? T.CollectionEquivalent
    }
    
    public static func parsePath(_ path: String) -> String? {
        var path = path
        if path.contains("{UserID}") {
            guard let uid = BasicInformation.uid else {
                print("Database.parsePath will return nil. Path contained {UserID} but UserID is nil")
                return nil
            }
            path = path.replacingOccurrences(of: "{UserID}", with: uid)
        }
        if path.contains("{NewDoc}") && path.hasSuffix("{NewDoc}" + path.suffix(10)) {
            let collectionPath = path.components(separatedBy: "/").dropLast().joined(separator: "/")
            let uid = Self.db.collection(collectionPath).addDocument(data: [:]).documentID
            path = collectionPath + "/\(uid)"
        }
        return path
    }
    
    public func fetch<T: Fetchable2>(_ item: T.Type, count: Int = 30) {
        print("\(item): Database.fetch did begin")
        guard let path = Self.parsePath(T.queryPath) else {
            print("\(item): Database.fetch did fail")
            return
        }
        
        let pathDepth = path.components(separatedBy: "/").count
        if pathDepth % 2 == 1 {
            var query = Self.db.collection(path).limit(to: count)
            if let orderField = T.queryOrderField {
                query = query.order(by: orderField, descending: T.queryShouldDescend ?? false)
            }
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("\(item): Database.fetch did fail. \(error.localizedDescription)")
                    return
                }
                
                var documents: [T.DocumentEquivalent] = []
                snapshot?.documents.forEach { (dbDocument) in
                    documents.append(T.DocumentEquivalent.create(from: dbDocument) as! T.DocumentEquivalent)
                }
                
                self.save(T(documents: documents))
            }
        }else {
            let ref = Self.db.document(path)
            ref.getDocument { (snapshot, error) in
                if let error = error {
                    print("\(item): Database.fetch did fail. \(error.localizedDescription)")
                }
                if let snapshot = snapshot {
                    let document: T.DocumentEquivalent = T.DocumentEquivalent.create(from: snapshot) as! T.DocumentEquivalent
                    self.save(T(documents: [document]))
                }
            }
        }
        print("\(item): Database.fetch did succeed")
    }
    
    public func upload<T: Uploadable>(_ item: T) {
        print("\(T.self): Database.upload did begin")
        guard let path = Self.parsePath(item.uploadPath) else {
            print("\(T.self): Database.upload did fail. Path could not be parsed (likely due to lack of sign in)")
            return
        }
        let document = Self.db.document(path)
        item.inject(into: document)
    }
}





// wrapper that makes metatypes hashable
// https://stackoverflow.com/questions/42459484/make-a-swift-dictionary-where-the-key-is-type
public struct HashableType<T>: Hashable {
    public let base: T.Type
    
    public init(_ base: T.Type) {
        self.base = base
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(base))
    }
    public static func == (lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.base == rhs.base
    }
}
// allows dictionary to interpret keys of type metatype (using HashableType wrapper)
// carries a performance penalty (O(n) copy) if Dictionary values are arrays (which they are)
// https://stackoverflow.com/questions/42459484/make-a-swift-dictionary-where-the-key-is-type
//extension Dictionary {
//    subscript<T>(key: T.Type) -> Value? where Key == HashableType<T> {
//        get {return self[HashableType(key)]}
//        set {self[HashableType(key)] = newValue}
//    }
//}
public protocol Timestamped {
    var lastModified: Date { get set }
}

public class TimestampedClass: Timestamped {
    public var lastModified: Date = Date()
}
