//
//  ProfileViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionSizeLabel: UILabel!

    let collectionViewColumnCount: CGFloat = 3
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()

        nameLabel.adjustsFontSizeToFitWidth = true

        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.nameLabel.text = user?.displayName
            self.nameLabel.setNeedsLayout()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func onSettingsClick(_ sender: Any) {
        print("Settings button was clicked!")// TODO
        AppDelegate.signOut()
    }

}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /*cell spacing x*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {return 20}
    /*cell spacing y*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return 20}
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interitemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let sumWhitespace = (collectionViewColumnCount - 1.0)*interitemSpacing
        let cellEdgeLength = (collectionView.bounds.width - sumWhitespace)/collectionViewColumnCount
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
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? StrengthCell else {return}
        cell.strengthName.adjustsFontSizeToFitWidth = true
        cell.hasThisStrength = CLPUser.shared().strengthsAsStrings().contains(strengths[indexPath.row].name)
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StrengthCell", bundle: nil), forCellWithReuseIdentifier: "StrengthCell")

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)

        collectionView.allowsSelection = false
        collectionView.reloadData()
    }
}
