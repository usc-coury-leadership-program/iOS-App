//
//  ProfileViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//    // MARK: - Configuration
//
//    internal func configure(collectionView: UICollectionView) {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
//
//        collectionView.register(UINib(nibName: "RC_Meal", bundle: nil), forCellWithReuseIdentifier: "RC_Meal")
//        collectionView.register(UINib(nibName: "TodayHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodayHeader")
//    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strengths.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StrengthCell", for: indexPath) as! StrengthCell
        cell.strengthName.text = strengths[indexPath.row].name
//        cell.strengthName.backgroundColor = UIColor.white
        cell.image.image = strengths[indexPath.row].image
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: RoundedCard.cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: TodayHeader.viewHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        return TodayHeader.dequeue(fromCollectionView: collectionView, ofKind: kind, atIndexPath: indexPath)
//    }


    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

//        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)

        collectionView.register(UINib(nibName: "StrengthCell", bundle: nil), forCellWithReuseIdentifier: "StrengthCell")

        collectionView.reloadData()
    }
}
