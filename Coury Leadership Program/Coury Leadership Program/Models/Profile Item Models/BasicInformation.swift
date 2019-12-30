//
//  BasicInformation.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public class BasicInformation: TimestampedClass, DBDocumentParser {
    public static var name: String? {return Auth.auth().currentUser?.displayName}
    public static var uid: String? {return Auth.auth().currentUser?.uid}
    
    public var strengths: [String] = [] {
        didSet {
            lastModified = Date()
        }
    }
    public var values: [String] = [] {
        didSet {
            lastModified = Date()
        }
    }
    
    public init(strengths: [String], values: [String]) {
        self.strengths = strengths
        self.values = values
        super.init()
    }
    
    public required convenience init(documents: [BasicInformation]) {
        if documents.count != 1 {fatalError("BasicInformation should never be initialized with an array containing multiple BasicInformation's")}
        self.init(strengths: documents.first!.strengths, values: documents.first!.values)
        // Self.self is equivalent to BasicInformation.self
        Database2.shared.register(Self.self) {self.checkFetchSuccess()}
    }
    
    public static func create(from dbDocument: DocumentSnapshot) -> DBDocumentParser {
        if BasicInformation.uid != dbDocument.documentID {fatalError("uid mismatch  while parsing BasicInformation. This implies a failure of Firebase rules online")}
        let data = dbDocument.data()!
        
        
        var strengths: [String] = [], values: [String] = []
        for entry in data {
            switch entry.key {
            case "strengths":
                strengths = entry.value as! [String]
            case "values":
                values = entry.value as! [String]
            default:
                break
            }
        }
        
        return BasicInformation(strengths: strengths, values: values)
    }
}

extension BasicInformation: Fetchable2 {
    public static var queryPath: String {return "Users/{UserID}"}
    public static let queryOrderField: String? = nil
    public static let queryShouldDescend: Bool? = nil
    
    public var localValue: BasicInformation {
        get {return self}
        set {
            strengths = newValue.strengths
            values = newValue.values
        }
    }
    
    public static var callbacks: [() -> Void] = []
    public static var activeProcesses: [Timer] = []
}

extension BasicInformation: Uploadable {
    public var uploadPath: String {return "Users/{UserID}"}
    
    public func inject(into dbDocument: DocumentReference) {
        dbDocument.setData([
            "strengths": strengths,
            "values": values
        ])
    }
}

extension BasicInformation: Hashable {
    public static func == (lhs: BasicInformation, rhs: BasicInformation) -> Bool {
        return (lhs.strengths) == (rhs.strengths) && (lhs.values == rhs.values)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(strengths)
        hasher.combine(values)
    }
}
