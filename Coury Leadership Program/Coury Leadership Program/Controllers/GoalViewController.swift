//
//  FeedViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    internal var lastUpdated: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        headerView.leftButton.isHidden = true
        headerView.rightButton.isHidden = true
        headerView.leftButton.isEnabled = false
        headerView.rightButton.isEnabled = false
        headerView.title.text = "Your Goals"
        engageTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + self.headerView.frame.height + 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: self.headerView.frame.height, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CLPProfile.shared.onFetchSuccess {
            self.updateTableView()
        }
        if CLPProfile.shared.goals.lastModified > lastUpdated {
            updateTableView()
        }
    }
    
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            guard let cell = tableView.cellForRow(at: indexPath) as? InteractiveTableableCell else {return}
            
            switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    cell.onLongPress(began: true)
                }, completion: nil)
                
            case .ended:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    cell.onLongPress(began: false)
                }, completion: nil)
                
                let goal = CLPProfile.shared.goals.goals.unachieved[indexPath.row]
                goal.achieved = true
                //setting like this (rather than calling goal.startUploading()) ensures that lastModified gets updated
                CLPProfile.shared.set(goal: goal, sync: true)
                tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                
            default:
                break
            }
        }

    }
}


extension GoalViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let toVC = segue.destination
        
        switch segue.identifier {
        case "AddGoalSegue": toVC.preferredContentSize = CGSize(width: view.bounds.width, height: 300)
        default: break
        }
        
        let ppc = toVC.popoverPresentationController!
        ppc.delegate = self
        ppc.sourceView = view
        ppc.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY - 150, width: view.bounds.width, height: 300)
        ppc.backgroundColor = .clear
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {}
    @IBAction func unwindToGoals(_ unwindSegue: UIStoryboardSegue) {
        guard let addGoalController = unwindSegue.source as? AddGoalViewController else {return}
        // Obtain the text of the goal from VC's UITextView
        let text = addGoalController.textView.text!
        if text != "" {
            // Obtain strength (if selected)
            let strengthIndex = addGoalController.strengthPicker.selectedRow(inComponent: 0)
            let strength = strengthIndex == 0 ? "" : STRENGTH_LIST[strengthIndex - 1].name
            // Obtain value (if selected)
            let valueIndex = addGoalController.valuePicker.selectedRow(inComponent: 0)
            let value = valueIndex == 0 ? "" : VALUE_LIST[valueIndex - 1].name
            
            // Create goal
            let goal = Goals.Goal(text: text, strength: strength, value: value, achieved: false, uid: nil)
            CLPProfile.shared.set(goal: goal, sync: true)
            
            updateTableView()
        }
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {}
}


extension GoalViewController: UITableViewDataSource, UITableViewDelegate {

    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0}
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return GoalCell.HEIGHT}
    // footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}

    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CLPProfile.shared.goals.goals.unachieved.count
    }
    // cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CLPProfile.shared.goals.goals.unachieved[indexPath.row].generateCellFor(tableView, at: indexPath)
    }

    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        GoalCell.registerWith(tableView)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.estimatedRowHeight = GoalCell.HEIGHT
    }
    
    func updateTableView() {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
        lastUpdated = Date()
    }
}