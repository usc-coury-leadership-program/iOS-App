//
//  Fetchable2.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/27/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public protocol Fetchable2 {
    // the class that stores and organizes fetched data
    // constrained to be a subclass of HashableTypeSeed so that it can be put in the database's data dictionary
    associatedtype Fetched: HashableTypeSeed
    associatedtype Document: QueryDocumentConverter
    
    init(documents: [Document])
    
    static var queryPath: String { get }
    static var queryOrderField: String { get }
    static var queryShouldDescend: Bool { get }
    
    var localValue: Fetched { get set }
    static var databaseValue: Fetched? { get }
    
    
}


extension Fetchable2 {
    public static var databaseValue: Fetched? {return Database2.shared.data[Fetched.typehash] as? Fetched}
}


public protocol QueryDocumentConverter {
    init(dbDocument: QueryDocumentSnapshot)
}
