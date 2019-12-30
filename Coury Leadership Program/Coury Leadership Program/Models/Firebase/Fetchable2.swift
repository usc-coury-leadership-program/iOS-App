//
//  Fetchable2.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public protocol Fetchable2: class {
    // the class that stores and organizes fetched data
    // constrained to be a subclass of HashableTypeSeed so that it can be put in the database's data dictionary
    associatedtype CollectionEquivalent: TimestampedClass
    associatedtype DocumentEquivalent: DBDocumentParser
    
    init(documents: [DocumentEquivalent])
    
    static var queryPath: String { get }
    static var queryOrderField: String? { get }
    static var queryShouldDescend: Bool? { get }
    
    var localValue: CollectionEquivalent { get set }
    static var databaseValue: CollectionEquivalent? { get }
    func overwriteLocalWithDatabase() -> Bool
    
    static var process: Timer? { get set }
    static var callbacks: [() -> Void] { get set }
    static func startFetching()
    static func stopFetching()
    static func onFetchSuccess(callback: @escaping () -> Void)
    static func clearFetchSuccessCallbacks()
    func checkFetchSuccess()
}

extension Fetchable2 {
    public static var databaseValue: CollectionEquivalent? {
        return Database2.shared.read(Self.self)
    }
    
    public static func startFetching() {
        stopFetching()
        process = Timer(timeInterval: 2.0, repeats: true) { _ in
            Database2.shared.fetch(Self.self, count: 30)
        }
        RunLoop.current.add(process!, forMode: .common)
    }
    public static func stopFetching()                                   {process?.invalidate()}
    public static func onFetchSuccess(callback: @escaping () -> Void)   {callbacks.append(callback)}
    public static func clearFetchSuccessCallbacks()                     {callbacks = []}
    
    public func checkFetchSuccess() {
        print("\(Self.self): Fetchable.checkFetchSuccess did begin")
        if Self.databaseValue != nil {
            print("\(Self.self): Fetchable.checkFetchSuccess did enter success clause")
            Self.stopFetching()
            Self.callbacks.forEach({$0()})
            Self.clearFetchSuccessCallbacks()
        }
    }
    
    public func overwriteLocalWithDatabase() -> Bool {
        guard let databaseValue = Self.databaseValue else {return false}
        localValue = databaseValue
        return true
    }
}


public protocol DBDocumentParser {
    static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser
}
