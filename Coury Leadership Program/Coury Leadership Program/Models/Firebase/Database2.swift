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
    
    private static let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    private var callbacks: [HashableType<Fetchable2> : [() -> Void]] = [:]
    /*
     * EXAMPLE
     * callbacks[SomeFetchableClass.self] = []
     */
    public private(set) var data: [HashableType<Fetchable2> : Fetchable2] = [:]
    
    // private constructor
    private init() {}
    
    // TODO item isn't really necessary in theory
    public func register<T: Fetchable2>(_ item: T, callback: @escaping () -> Void) {
        callbacks[T.hashable] = (callbacks[T.hashable] ?? []) + [callback]
    }
    
    public func clear() {
        callbacks = [:]
    }
    
    private func save<T: Fetchable2>(_ item: T) {
        data[T.hashable] = item
        callbacks[T.hashable]?.forEach({$0()})
    }
}

public class Fetchable2 {
    static var hashable: HashableType<Fetchable2> = HashableType(Fetchable2.self)
    static var databaseValue: Fetchable2? {
        get {return Database2.shared.data[hashable]}
    }
}
public protocol Fetchable2Requirements {
    associatedtype T: Fetchable2
}
/*
 * EXAMPLE
 * class Calendar: Fetchable2, Fetchable2Requirements {
 *  typealias T = Calendar
 *  //...
 * }
 */


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
