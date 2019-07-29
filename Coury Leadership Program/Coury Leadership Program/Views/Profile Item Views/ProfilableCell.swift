//
//  ProfilableCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol ProfilableCell {

    static var REUSE_ID: String { get }

    static func getUINib() -> UINib
    static func registerWith(_ collectionView: UICollectionView)
    static func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell

//    func onTap()
//    func onLongPress(began: Bool)
//    func setSaved(to: Bool)
    func setHas(to: Bool)

}

extension ProfilableCell {
    static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    static func registerWith(_ collectionView: UICollectionView) {collectionView.register(getUINib(), forCellWithReuseIdentifier: REUSE_ID)}
    static func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_ID, for: indexPath)
    }
}

extension UICollectionViewCell {
    func configureShadow() {
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.black.cgColor
    }
    func showShadow() {layer.shadowOpacity = 0.3}
    func hideShadow() {layer.shadowOpacity = 0.0}
}
