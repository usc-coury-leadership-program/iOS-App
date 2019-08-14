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
    @IBOutlet weak var helpText: UILabel!

    private let collectionViewColumnCount: CGFloat = 3
    private var selectingType: SelectingType = .values
    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    private enum SelectingType {case values, strengths}
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
    /*number of rows    */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectingType {
        case .values: return VALUE_LIST.count
        case .strengths: return STRENGTH_LIST.count
        }
    }

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch selectingType {
        case .values: return VALUE_LIST[indexPath.row].generateCellFor(collectionView, at: indexPath)
        case .strengths: return STRENGTH_LIST[indexPath.row].generateCellFor(collectionView, at: indexPath)
        }
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ProfilableCell)?.setHas(to: cell.isSelected)
    }

    //selecting
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfilableCell
        cell.setHas(to: true)

        if (isSelectionCount(of: collectionView, 5)) {
            switch selectingType {
            case .values:
                CLPProfile.shared.set(values: collectionView.indexPathsForSelectedItems!.map() { (indexPath) -> String in
                    return VALUE_LIST[indexPath.row].name
                })
                selectingType = .strengths
                helpText.text = "Great! Now your top 5 Clifton Strengths:"
                collectionView.reloadData()


            case .strengths:
                CLPProfile.shared.set(strengths: collectionView.indexPathsForSelectedItems!.map() { (indexPath) -> String in
                    return STRENGTH_LIST[indexPath.row].name
                })
                AppDelegate.signIn()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //deselecting
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfilableCell
        cell.setHas(to: false)
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        ValueCell.registerWith(collectionView)
        StrengthCell.registerWith(collectionView)

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
