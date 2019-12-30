//
//  ProfileViewCollectionView.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //cell spacing x
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {return 20}
    //cell spacing y
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return 20}
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interitemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let sumWhitespace = (collectionViewColumnCount - 1)*interitemSpacing
        let cellEdgeLength = (collectionView.bounds.width - 2*collectionView.contentInset.left - sumWhitespace)/collectionViewColumnCount
        return CGSize(width: cellEdgeLength, height: cellEdgeLength)
    }
    //footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }

    //number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 2}
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return VALUE_LIST.count
        case 1: return STRENGTH_LIST.count
        default: return 0
        }
    }

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: return VALUE_LIST[indexPath.row].generateCellFor(collectionView, at: indexPath)
        case 1: return STRENGTH_LIST[indexPath.row].generateCellFor(collectionView, at: indexPath)
        default: fatalError("Profile's CollectionView has more sections than expected.")
        }
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //cell.showShadow()
        switch indexPath.section {
        case 0: (cell as? ProfileViewCell)?.setHas(to: CLPProfile.shared.has(value: VALUE_LIST[indexPath.row]))
        case 1: (cell as? ProfileViewCell)?.setHas(to: CLPProfile.shared.has(strength: STRENGTH_LIST[indexPath.row]))
        default: break
        }
    }
    // cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        switch indexPath.section{
        case 0: performSegue(withIdentifier: "ValueDetailSegue", sender: cell)
        case 1: performSegue(withIdentifier: "StrengthDetailSegue", sender: cell)
        default: fatalError("Profile's CollectionView has more sections than expected.")
        }

    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        ValueCell.registerWith(collectionView)
        StrengthCell.registerWith(collectionView)

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: visualEffectHeader.frame.maxY + 20.0, left: 16.0, bottom: 20.0, right: 16.0)

        collectionView.allowsSelection = true
        collectionView.reloadData()
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
        collectionView.layoutSubviews()
    }
    
    func hideCollectionView(_ shouldHide: Bool) {
        collectionView.isHidden = shouldHide
        collectionView.isUserInteractionEnabled = !shouldHide
    }
}
