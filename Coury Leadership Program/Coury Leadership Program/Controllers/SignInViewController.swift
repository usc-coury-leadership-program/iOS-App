//
//  SignInViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 4/6/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionViewColumnCount: CGFloat = 3
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        self.dismiss(animated: true, completion: nil)
//    }

}


extension SignInViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

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
    /*number of rows    */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return values.count}

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StrengthCell", for: indexPath) as! ValueCell
        cell.valueName.text = values[indexPath.row].shortName()
        cell.image.image = values[indexPath.row].image
        return cell
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ValueCell else {return}
        cell.valueName.adjustsFontSizeToFitWidth = true
    }

    //selecting
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ValueCell
        cell.hasThisValue = true
        if (isSelectionCount(of: collectionView, 5)) {
            CLPUser.shared().set(strengths: collectionView.indexPathsForSelectedItems!.map() { (indexPath) -> String in
                return values[indexPath.row].name
            })
            AppDelegate.signIn()
            self.dismiss(animated: true, completion: nil)
        }
    }
    //deselecting
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ValueCell
        cell.hasThisValue = false
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ValueCell", bundle: nil), forCellWithReuseIdentifier: "ValueCell")

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)

        collectionView.allowsMultipleSelection = true
        collectionView.reloadData()
    }

    func isSelectionCount(of collectionView: UICollectionView, _ number: Int) -> Bool {
        guard let selection = collectionView.indexPathsForSelectedItems else {return false}
        return selection.count == number
    }
}
