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
    @IBOutlet weak var visualEffectHeader: UIVisualEffectView!

    let collectionViewColumnCount: CGFloat = 3
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()

        nameLabel.text = ""
        nameLabel.adjustsFontSizeToFitWidth = true
        collectionSizeLabel.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.nameLabel.text = user?.displayName
            self.nameLabel.setNeedsLayout()
            self.collectionSizeLabel.text = String(CLPUser.shared().savedContent?.count ?? 0)
            self.collectionSizeLabel.setNeedsLayout()
            self.collectionView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if handle != nil {Auth.auth().removeStateDidChangeListener(handle!)}
    }

    @IBAction func onSettingsClick(_ sender: Any) {AppDelegate.signOut()}
}

extension ProfileViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
//        if sender.state == .began {
//            let touchPoint = sender.location(in: self.collectionView)
//            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
//                let cell = collectionView.cellForItem(at: indexPath) as! StrengthCell
//                print(cell.strengthName.text)
//                performSegue(withIdentifier: "StrengthDetailSegue", sender: cell)
//            }
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ValueDetailSegue" {
            guard let cell = sender as? ValueCell, let toVC = segue.destination as? ValueDetailViewController else {return}

            toVC.value = cell.value
            toVC.preferredContentSize = CGSize(width: collectionView.contentSize.width, height: 500)

            let ppc = toVC.popoverPresentationController!
            ppc.delegate = self
            ppc.sourceView = collectionView
            ppc.sourceRect = CGRect(x: collectionView.bounds.midX, y: collectionView.bounds.midY + collectionView.contentInset.top/2.0, width: 0, height: 0)
            ppc.backgroundColor = .clear
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ValueCell", for: indexPath) as! ValueCell
        cell.value = strengths[indexPath.row]
        cell.valueName.text = strengths[indexPath.row].shortName()
        cell.image.image = strengths[indexPath.row].image
        return cell
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ValueCell else {return}
        cell.valueName.adjustsFontSizeToFitWidth = true
        guard let userStrengthList = CLPUser.shared().strengths else {cell.hasThisValue = false; return}
        cell.hasThisValue = userStrengthList.contains(strengths[indexPath.row].name)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ValueCell
        performSegue(withIdentifier: "ValueDetailSegue", sender: cell)
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ValueCell", bundle: nil), forCellWithReuseIdentifier: "ValueCell")

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: visualEffectHeader.frame.maxY + 20.0, left: 0.0, bottom: 20.0, right: 0.0)

        collectionView.allowsSelection = true
        collectionView.reloadData()
    }
}
