//
//  FeedItem.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import CoreMotion

public protocol FeedableCell {

    static var HEIGHT: CGFloat { get }
    static var REUSE_ID: String { get }

//    var insetView: UIView! { get set }

    static func getUINib() -> UINib
    static func registerWith(_ tableView: UITableView)
    static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

    func onTap()
    
}

extension FeedableCell {
    static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    static func registerWith(_ tableView: UITableView) {tableView.register(getUINib(), forCellReuseIdentifier: REUSE_ID)}
    static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {return tableView.dequeueReusableCell(withIdentifier: REUSE_ID, for: indexPath)}
}

extension UITableViewCell {

    func addShadow(around layer: CALayer) {
        let path = UIBezierPath(rect: layer.bounds.insetBy(dx: 0.0, dy: 0.0))

        layer.shadowRadius = 8
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = path.cgPath
        layer.masksToBounds = false
    }

    func removeShadow(from layer: CALayer) {layer.shadowOpacity = 0.0}

}
