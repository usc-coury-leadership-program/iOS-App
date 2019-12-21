//
//  Quote.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/18/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation

public struct Quote: ContentCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = QuoteCell.self

    let quoteText: String
    let author: String
    public let uid: String
    public let shouldDisplay: Bool = true
    
    public static func == (lhs: Quote, rhs: Quote) -> Bool {return lhs.uid == rhs.uid}
    public func hash(into hasher: inout Hasher) {hasher.combine(uid)}
}
