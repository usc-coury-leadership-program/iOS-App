//
//  ProfilableData.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol CollectionableCellData {
    var CorrespondingView: CollectionableCell.Type { get }
    
    func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell
}
extension CollectionableCellData {
    public func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell {
        return CorrespondingView.insideOf(collectionView, at: indexPath).populatedBy(self, at: indexPath)
    }
}
