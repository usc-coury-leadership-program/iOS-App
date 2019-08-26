//
//  ProfilableData.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol ProfilableData {
    func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}

protocol Named {
    var name: String { get }
}
