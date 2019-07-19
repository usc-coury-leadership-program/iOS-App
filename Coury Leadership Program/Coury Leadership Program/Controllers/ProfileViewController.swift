//
//  ProfileViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import CoreMotion
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionSizeLabel: UILabel!
    @IBOutlet weak var visualEffectHeader: UIVisualEffectView!
    @IBOutlet weak var visualEffectForPPC: UIVisualEffectView!
    
    let collectionViewColumnCount: CGFloat = 3
    var handle: AuthStateDidChangeListenerHandle?
    private let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()
        nameLabel.adjustsFontSizeToFitWidth = true

        updateUserSpecificText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.updateUserSpecificText()
            self.collectionView.reloadData()
        }
        //engageMotionShadows()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if handle != nil {Auth.auth().removeStateDidChangeListener(handle!)}
//        disengageMotionShadows()
    }

    func updateUserSpecificText() {
        nameLabel.text = CLPUser.shared().name
        let userScore = (CLPUser.shared().savedContent?.count ?? 0) + (CLPUser.shared().answeredPolls?.count ?? 0)
        collectionSizeLabel.text = String(userScore)
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
        if segue.identifier == "AboutSegue" {return}

        let toVC = segue.destination
        
        switch segue.identifier {
        case "ValueDetailSegue":
            guard let cell = sender as? ValueCell else {return}
            (toVC as! ValueDetailViewController).value = cell.value
            toVC.preferredContentSize = CGSize(width: collectionView.contentSize.width, height: 460)

        case "StrengthDetailSegue":
            guard let cell = sender as? StrengthCell else {return}
            (toVC as! StrengthDetailViewController).strength = cell.strength
            toVC.preferredContentSize = CGSize(width: collectionView.contentSize.width, height: 400)

        default: break
        }

        let ppc = toVC.popoverPresentationController!
        ppc.delegate = self
        ppc.sourceView = collectionView
        ppc.sourceRect = CGRect(x: collectionView.bounds.midX, y: collectionView.bounds.midY/* + collectionView.contentInset.top/2.0*/, width: 0, height: 0)
        ppc.backgroundColor = .clear
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {visualEffectForPPC.isHidden = false}
    @IBAction func unwindToProfile(_ unwindSegue: UIStoryboardSegue) {visualEffectForPPC.isHidden = true}
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {visualEffectForPPC.isHidden = true}
}

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
    //number of rows
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
        case 0: (cell as? ProfilableCell)?.setHas(to: CLPUser.shared().values?.contains(VALUE_LIST[indexPath.row].name) ?? false)
        case 1: (cell as? ProfilableCell)?.setHas(to: CLPUser.shared().strengths?.contains(STRENGTH_LIST[indexPath.row].name) ?? false)
        default: break
        }
    }

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
}

extension ProfileViewController {

    private func engageMotionShadows() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                guard let motion = motion else {return}
                for cell in self.collectionView.visibleCells {cell.adjustShadow(pitch: motion.attitude.pitch, roll: motion.attitude.roll)}
            }
        }
    }

    private func disengageMotionShadows() {motionManager.stopDeviceMotionUpdates()}

}
