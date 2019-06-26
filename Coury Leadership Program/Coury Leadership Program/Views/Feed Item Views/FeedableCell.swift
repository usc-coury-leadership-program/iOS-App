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

    var insetView: UIView! { get set }

    static func getUINib() -> UINib
    static func registerWith(_ tableView: UITableView)
    static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

    func onTap(inContext vc: UIViewController)
    func onLongPress(began: Bool)
    func setSaved(to: Bool)
    
}

extension FeedableCell {
    static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    static func registerWith(_ tableView: UITableView) {tableView.register(getUINib(), forCellReuseIdentifier: REUSE_ID)}
    static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: REUSE_ID, for: indexPath)
    }

    func configureShadow() {
        insetView.layer.shadowRadius = 8
        insetView.layer.shadowOffset = CGSize.zero
        insetView.layer.shadowColor = UIColor.black.cgColor
    }
    func showShadow() {insetView.layer.shadowOpacity = 0.4}
    func adjustShadow(pitch: Double, roll: Double) {
//        insetView.layer.shadowPath = UIBezierPath(rect: insetView.layer.bounds).cgPath
        insetView.layer.shadowOffset = CGSize(width: roll*2.0, height: pitch*2.0)
    }
    func hideShadow() {insetView.layer.shadowOpacity = 0.0}
}
