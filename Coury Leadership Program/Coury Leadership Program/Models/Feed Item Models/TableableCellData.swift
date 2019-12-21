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
    var uid: String { get }
    var shouldDisplay: Bool { get }
    
    func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell
}
extension TableableCellData {
    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell {
        return CorrespondingView.insideOf(tableView, at: indexPath).populatedBy(self, at: indexPath)
    }
}
extension Array where Element == TableableCellData {
    var shouldBeShown: [Element] {
        return self.filter({$0.shouldDisplay})
    }
}

public protocol ContentCellData: TableableCellData {
    var isLiked: Bool { get }
    func toggleLike()
}
extension ContentCellData {
    public var isLiked: Bool {
        get {return CLPProfile.shared.has(savedContent: uid)}
    }
    public func toggleLike() {
        CLPProfile.shared.toggle(savedContent: uid)
    }
}
extension Array where Element == ContentCellData {
    var shouldBeShown: [Element] {
        return self.filter({$0.shouldDisplay})
    }
    var thatsBeenLiked: [Element] {
        return self.filter({$0.isLiked})
    }
}

