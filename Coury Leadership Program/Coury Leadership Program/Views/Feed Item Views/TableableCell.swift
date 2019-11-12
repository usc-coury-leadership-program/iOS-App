//
//  FeedItem.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol TableableCell {
    static var HEIGHT: CGFloat { get }
    static var REUSE_ID: String { get }

    static func getUINib() -> UINib
    static func registerWith(_ tableView: UITableView)
    static func insideOf(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell
}
extension TableableCell {
    public static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    public static func registerWith(_ tableView: UITableView) {tableView.register(getUINib(), forCellReuseIdentifier: REUSE_ID)}
    public static func insideOf(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: REUSE_ID, for: indexPath) as! AUITableViewCell
    }
}


//=======================================================================


public protocol InteractiveTableableCell: TableableCell {
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer)
    func onLongPress(began: Bool)
}


//=======================================================================


public protocol FeedViewCell: InteractiveTableableCell {
    var insetView: UIView! { get set }
    func setSaved(to: Bool)
}
extension FeedViewCell {
    func configureShadow() {
        insetView.layer.shadowRadius = 8
        insetView.layer.shadowOffset = CGSize.zero
        insetView.layer.shadowColor = UIColor.black.cgColor
    }
    func showShadow() {insetView.layer.shadowOpacity = 0.4}
    func hideShadow() {insetView.layer.shadowOpacity = 0.0}
}


//=======================================================================


public class AUITableViewCell: UITableViewCell {
    public var indexPath: IndexPath?
    public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        self.indexPath = indexPath
        return self
    }
}
