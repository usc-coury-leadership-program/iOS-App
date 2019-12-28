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
    
    private var callbacks: [HashableType<HashableTypeSeed> : [() -> Void]] = [:]
    /*
     * EXAMPLE
     * callbacks[SomeFetchableClass.self] = []
     */
    public private(set) var data: [HashableType<HashableTypeSeed> : HashableTypeSeed] = [:]
    
    // private constructor
    private init() {}
    
//    // TODO item isn't really necessary in theory
//    public func register<T: HashableTypeSeed>(_ item: T, callback: @escaping () -> Void) {
//        callbacks[T.typehash] = (callbacks[T.typehash] ?? []) + [callback]
//    }
    // TODO item isn't really necessary in theory
    public func register<T: Fetchable2>(_ item: T, callback: @escaping () -> Void) {
        callbacks[T.Fetched.typehash] = (callbacks[T.Fetched.typehash] ?? []) + [callback]
    }
    
    public func clear() {
        callbacks = [:]
    }
    
//    private func save<T: HashableTypeSeed>(_ item: T) {
//        data[T.typehash] = item
//        callbacks[T.typehash]?.forEach({$0()})
//    }
    private func save<T: Fetchable2>(_ item: T) {
        data[T.Fetched.typehash] = item.localValue
        callbacks[T.Fetched.typehash]?.forEach({$0()})
    }
    
    public func fetch<T: Fetchable2>(_ item: inout T, count: Int = 30) {
        Database2.db.collection(T.queryPath).order(by: T.queryOrderField, descending: T.queryShouldDescend).limit(to: count).getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to fetch \(item.self): \(error.localizedDescription)")
                return
            }
            
            var documents: [T.Document] = []
            // the snapshot is the database's representation of T.Fetched
            snapshot?.documents.forEach { (dbDocument) in
                // the document is the database's representation of T.Document
                documents.append(T.Document(dbDocument: dbDocument))
            }
            
            self.save(T(documents: documents))
        }
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
// provides a variable, solely dependent on the Type, that can be interpreted as the key of a dictionary
// carries negligible performance penalty
public class HashableTypeSeed {
    static var typehash: HashableType<HashableTypeSeed> = HashableType(HashableTypeSeed.self)
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
