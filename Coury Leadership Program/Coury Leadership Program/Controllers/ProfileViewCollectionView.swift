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
    //header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 2)
    }
    //footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }

    //number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 2}
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return (selectedSegment == 0) ? VALUE_LIST.owned.count : STRENGTH_LIST.owned.count
        case 1: return (selectedSegment == 0) ? VALUE_LIST.unowned.count : STRENGTH_LIST.unowned.count
        default: return 0
        }
    }

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let data: CollectionableCellData = (selectedSegment == 0) ? VALUE_LIST.owned[indexPath.row] : STRENGTH_LIST.owned[indexPath.row]
            return data.generateCellFor(collectionView, at: indexPath)
        case 1:
            let data: CollectionableCellData = (selectedSegment == 0) ? VALUE_LIST.unowned[indexPath.row] : STRENGTH_LIST.unowned[indexPath.row]
            return data.generateCellFor(collectionView, at: indexPath)
        default:
            fatalError("Profile's CollectionView has more sections than expected.")
        }
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: (cell as? ProfileViewCell)?.setHas(to: true)
        case 1: (cell as? ProfileViewCell)?.setHas(to: false)
        default: break
        }
    }
    //cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        (selectedSegment == 0) ? performSegue(withIdentifier: "ValueDetailSegue", sender: cell) : performSegue(withIdentifier: "StrengthDetailSegue", sender: cell)
    }
    
    //header and footer generation
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: UICollectionReusableView
        switch kind {
        case "UICollectionElementKindSectionHeader":
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        case "UICollectionElementKindSectionFooter":
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        default:
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        }
        return view
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
        lastUpdated = Date()
    }
    
    func hideCollectionView(_ shouldHide: Bool) {
        collectionView.isHidden = shouldHide
        collectionView.isUserInteractionEnabled = !shouldHide
    }
}
