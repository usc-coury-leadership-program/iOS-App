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
    
    static var newProcess: Timer { get }
    static var activeProcesses: [Timer] { get set }
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
    
    // ideally would be internal
    public static var newProcess: Timer {
        return Timer(timeInterval: 2.0, repeats: true) { _ in
            Database2.shared.fetch(Self.self, count: 30)
        }
    }
    public static func startFetching()                                  {activeProcesses.append(newProcess); RunLoop.current.add(activeProcesses.last!, forMode: .common)}
    public static func stopFetching()                                   {activeProcesses.forEach({$0.invalidate()})}
    public static func onFetchSuccess(callback: @escaping () -> Void)   {callbacks.append(callback)}
    public static func clearFetchSuccessCallbacks()                     {callbacks = []}
    // ideally would be internal
    public func checkFetchSuccess() {
        if let databaseValue = Self.databaseValue {
            Self.stopFetching()
            localValue = databaseValue
            Self.callbacks.forEach({$0()})
            // TODO possibly clearFetchSuccessCallbacks() here?
        }
    }
}


public protocol DBDocumentParser {
    static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser
}
