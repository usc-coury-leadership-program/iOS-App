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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionSizeLabel: UILabel!
    @IBOutlet weak var visualEffectHeader: UIVisualEffectView!
    @IBOutlet weak var visualEffectForPPC: UIVisualEffectView!
    
    let collectionViewColumnCount: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageCollectionView()
        hideTableView(true)
        engageTableView()
        nameLabel.adjustsFontSizeToFitWidth = true

        updateUserSpecificText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Profile
        CLPProfile.shared.onFetchSuccess {
            self.updateUserSpecificText()
            self.updateCollectionView()
            self.updateTableView()
        }
        updateUserSpecificText()
        updateCollectionView()
        updateTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Profile
        CLPProfile.shared.clearFetchSuccessCallbacks()
    }

    func updateUserSpecificText() {
        nameLabel.text = BasicInformation.name
        let userScore = CLPProfile.shared.savedContent.savedPosts.count + CLPProfile.shared.answeredPolls.answeredPolls.count
        collectionSizeLabel.text = String(userScore)
    }
    
    @IBAction func onViewSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            hideCollectionView(false)
            hideTableView(true)
        }else {
            hideCollectionView(true)
            hideTableView(false)
        }
    }
    
    @IBAction func onSettingsClick(_ sender: Any) {AppDelegate.signOut()}
}

extension ProfileViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {return .none}
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {}

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
        ppc.sourceRect = CGRect(x: collectionView.bounds.midX, y: collectionView.bounds.midY, width: 0, height: 0)
        ppc.backgroundColor = .clear
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {visualEffectForPPC.isHidden = false}
    @IBAction func unwindToProfile(_ unwindSegue: UIStoryboardSegue) {visualEffectForPPC.isHidden = true}
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {visualEffectForPPC.isHidden = true}
}

