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

//    var insetView: UIView! { get set }

    static func getUINib() -> UINib
    static func registerWith(_ tableView: UITableView)
    static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

    func onTap()
    
}

extension UITableViewCell {
    func addInnerShadow(around layer: CALayer) {
        let innerShadow = CALayer()
        innerShadow.frame = layer.bounds
        
        // Shadow path (1pt ring around bounds)
        let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: 1.0, dy: 1.0))
        let cutout = UIBezierPath(rect: innerShadow.bounds).reversing()
        path.append(cutout)

        innerShadow.cornerRadius = 8
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true

        // Shadow properties
//        innerShadow.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowOpacity = 1.0
        innerShadow.shadowRadius = 4.0

        layer.addSublayer(innerShadow)
    }
}

extension UILabel {
    func addInnerShadow() {
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
    }
}
