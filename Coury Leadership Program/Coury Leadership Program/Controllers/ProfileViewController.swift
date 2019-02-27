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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionSizeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()

        nameLabel.adjustsFontSizeToFitWidth = true
    }

    @IBAction func onSettingsClick(_ sender: Any) {
        //TODO
        print("Settings button was clicked!")
    }

}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*cell spacing x*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {return 20}
    /*cell spacing y*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return 20}
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interitemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let cellEdgeLength = (collectionView.bounds.width - interitemSpacing)/2.0
        return CGSize(width: cellEdgeLength, height: cellEdgeLength)
    }

    /*number of sections*/func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    /*number of rows    */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return strengths.count}

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StrengthCell", for: indexPath) as! StrengthCell
        cell.strengthName.text = strengths[indexPath.row].name
        cell.image.image = strengths[indexPath.row].image
        return cell
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StrengthCell", bundle: nil), forCellWithReuseIdentifier: "StrengthCell")

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)

        collectionView.reloadData()
    }
}
