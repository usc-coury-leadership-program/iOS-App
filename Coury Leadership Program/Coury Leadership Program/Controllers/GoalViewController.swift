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


extension GoalViewController {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let toVC = segue.destination
        
        switch segue.identifier {
        case "AddGoalSegue": break
        default: break
        }
    }

    @IBAction func unwindToGoals(_ unwindSegue: UIStoryboardSegue) {
        guard let addGoalController = unwindSegue.source as? AddGoalViewController else {return}
        
        let value = AddGoalViewController.activeValueForRecs
        let due = addGoalController.datePicker.date
        
        let text: String
        switch addGoalController.selectedSegment {
//        case 0:
//            guard let indexPath = addGoalController.tableView.indexPathForSelectedRow else {
//                text = ""
//                break
//            }
//            text = AddGoalViewController.activeRecommendations[indexPath.row]
//        case 1:
//            guard let indexPath = addGoalController.tableView.indexPathForSelectedRow else {
//                text = ""
//                break
//            }
//            text = (addGoalController.tableView.cellForRow(at: indexPath) as! RecommendedCell).textView.text
        default:
            text = ""
        }
        
        // Create goal
        if text != "" {
            let goal = Goals.Goal(text: text, due: due, strength: nil, value: value, achieved: false, uid: nil)
            CLPProfile.shared.set(goal: goal, sync: true)

            updateTableView()
        }
    }
}


extension GoalViewController: UITableViewDataSource, UITableViewDelegate {

    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0}
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
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func updateTableView() {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
        lastUpdated = Date()
    }
}
