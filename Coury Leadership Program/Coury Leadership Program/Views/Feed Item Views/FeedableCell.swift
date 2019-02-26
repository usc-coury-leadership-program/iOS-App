//
//  FeedItem.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol FeedableCell {

    static var HEIGHT: CGFloat { get }
    static var REUSE_ID: String { get }

    static func getUINib() -> UINib
    static func registerWith(_ tableView: UITableView)
    static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    
}
