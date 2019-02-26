//
//  FeedableData.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol FeedableData {
    func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}
