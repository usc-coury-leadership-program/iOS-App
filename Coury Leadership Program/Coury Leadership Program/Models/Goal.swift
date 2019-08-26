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
}
