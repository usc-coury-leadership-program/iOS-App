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

class ProfileViewController: UIViewController, HeaderViewDelegate {
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var answeredPollsCount: UILabel!
    @IBOutlet weak var currentGoalsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var visualEffectHeader: UIVisualEffectView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let collectionViewColumnCount: CGFloat = 3
    internal var lastUpdated: Date = Date()
    internal var selectedSegment: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headerView.leftButton.setTitle("About", for: .normal)
        headerView.leftButton.setTitle("About", for: .highlighted)
        headerView.leftButton.setTitle("About", for: .selected)
        headerView.rightButton.setTitle("Logout", for: .normal)
        headerView.rightButton.setTitle("Logout", for: .highlighted)
        headerView.rightButton.setTitle("Logout", for: .selected)
        headerView.delegate = self
        
        engageCollectionView()
        hideTableView(true)
        engageTableView()

        updateUserSpecificText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CLPProfile.shared.onFetchSuccess {
            self.updateUserSpecificText()
            self.updateCollectionView()
            self.updateTableView()
        }
        
        if [CLPProfile.shared.basicInformation.lastModified,
            CLPProfile.shared.savedContent.lastModified,
            CLPProfile.shared.goals.lastModified].max()! > lastUpdated {
            updateUserSpecificText()
            updateCollectionView()
            updateTableView()
        }
    }

    func updateUserSpecificText() {
        headerView.title.text = BasicInformation.name
        answeredPollsCount.text = String(Feed.shared.polls.polls.answered.count)
        currentGoalsCount.text = String(CLPProfile.shared.goals.goals.unachieved.count)
//        segmentedControl.setTitle("Liked Posts - \(Feed.shared.posts.posts.liked.count)", forSegmentAt: 2)
        
        lastUpdated = Date()
    }
    
    @IBAction func onViewSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 2 {
            hideCollectionView(true)
            hideTableView(false)
        }else {
            hideCollectionView(false)
            hideTableView(true)
            selectedSegment = sender.selectedSegmentIndex
            updateCollectionView()
        }
    }
    
    func onLeftButtonTap() {
        performSegue(withIdentifier: "AboutSegue", sender: self)
    }
    
    func onRightButtonTap() {
        AppDelegate.signOut()
    }
}

extension ProfileViewController {
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "AboutSegue" {return}

        let toVC = segue.destination
        
        switch segue.identifier {
        case "ValueDetailSegue":
            guard let cell = sender as? ValueCell else {return}
            (toVC as! ValueDetailViewController).value = cell.value

        case "StrengthDetailSegue":
            guard let cell = sender as? StrengthCell else {return}
            (toVC as! StrengthDetailViewController).strength = cell.strength

        default: break
        }
    }

    @IBAction func unwindToProfile(_ unwindSegue: UIStoryboardSegue) {}
}

