//
//  TableableCellData.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol TableableCellData {
    var CorrespondingView: TableableCell.Type { get }
    func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell
}

extension TableableCellData {
    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell {
        return CorrespondingView.insideOf(tableView, at: indexPath).populatedBy(self, at: indexPath)
    }
}
