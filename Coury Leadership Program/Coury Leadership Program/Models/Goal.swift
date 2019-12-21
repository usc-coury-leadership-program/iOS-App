//
//  Goal.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 8/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation

public struct Goal: TableableCellData {
    public let CorrespondingView: TableableCell.Type = GoalCell.self
    
    let text: String
    let strength: Strength?
    let value: Value?
    public let uid: String
    public let shouldDisplay: Bool = true
    
    init(text: String, strength: Strength?, value: Value?, uid: String) {
        self.text = text
        self.strength = strength
        self.value = value
        self.uid = uid
    }
    
    init(text: String, strength: Strength?, value: Value?) {
        self.text = text
        self.strength = strength
        self.value = value
        self.uid = Database.shared.generateGoalUID()
    }
    
    init(text: String, strengthStr: String?, valueStr: String?, uid: String) {
        var strength: Strength?
        if strengthStr != nil {
            strength = STRENGTH_LIST.filter({$0.name == strengthStr})[0]
        }
        var value: Value?
        if valueStr != nil {
            value = VALUE_LIST.filter({$0.name == valueStr})[0]
        }
        self.init(text: text, strength: strength, value: value, uid: uid)
    }
    
    public func dict() -> [String : String] {
        var dict: [String: String] = ["text": text]
        if let strength = strength {dict["strength"] = strength.name}
        if let value = value {dict["value"] = value.name}
        return dict
    }
}
