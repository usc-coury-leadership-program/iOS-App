//
//  SignInViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 4/6/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionViewColumnCount: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("ran sign")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    /*number of rows    */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return strengths.count}

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StrengthCell", for: indexPath) as! StrengthCell
        cell.strengthName.text = strengths[indexPath.row].name
        cell.image.image = strengths[indexPath.row].image
        cell.hasThisStrength = true
        return cell
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? StrengthCell else {return}
        cell.strengthName.adjustsFontSizeToFitWidth = true
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
