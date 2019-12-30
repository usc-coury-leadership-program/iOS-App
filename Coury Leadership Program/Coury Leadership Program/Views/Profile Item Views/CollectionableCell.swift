//
//  ProfilableCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol CollectionableCell {
    
    static var REUSE_ID: String { get }

    static func getUINib() -> UINib
    static func registerWith(_ collectionView: UICollectionView)
    static func insideOf(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell
}
extension CollectionableCell {
    public static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    public static func registerWith(_ collectionView: UICollectionView) {collectionView.register(getUINib(), forCellWithReuseIdentifier: REUSE_ID)}
    public static func insideOf(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_ID, for: indexPath) as! AUICollectionViewCell
    }
}


//=======================================================================


public protocol ProfileViewCell: CollectionableCell {
    func setHas(to: Bool)
}


//=======================================================================


public class AUICollectionViewCell: UICollectionViewCell {
    public var indexPath: IndexPath?
    internal var data: CollectionableCellData?
    public func populatedBy(_ data: CollectionableCellData, at indexPath: IndexPath) -> AUICollectionViewCell {
        self.indexPath = indexPath
        self.data = data
        return self
    }
}

//extension UICollectionViewCell {
//    func configureShadow() {
//        layer.shadowRadius = 16
//        layer.shadowOffset = CGSize.zero
//        layer.shadowColor = UIColor.black.cgColor
//    }
//    func showShadow() {layer.shadowOpacity = 0.3}
//    func hideShadow() {layer.shadowOpacity = 0.0}
//}
