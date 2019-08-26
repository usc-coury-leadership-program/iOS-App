//
//  FeedViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engageTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    }
}


extension SavedViewController: UIPopoverPresentationControllerDelegate {
    
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
        
        let text = addGoalController.textView.text ?? ""
        let strengthIndex = addGoalController.strengthPicker.selectedRow(inComponent: 0)
        let strength = strengthIndex == 0 ? nil : STRENGTH_LIST[strengthIndex]
        let valueIndex = addGoalController.valuePicker.selectedRow(inComponent: 0)
        let value = valueIndex == 0 ? nil : VALUE_LIST[valueIndex]
        let goal = Goal(text: text, strength: strength, value: value)
        
        CLPProfile.shared.addNew(goal: goal)
        tableView.reloadData()
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {}
}


extension SavedViewController: UITableViewDataSource, UITableViewDelegate {

    /*header height*/func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0}
    /*cell height  */func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return GoalCell.HEIGHT}
    /*footer height*/func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}

    /*number of sections*/func numberOfSections(in tableView: UITableView) -> Int {return 1}
    /*number of rows    */func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CLPProfile.shared.goals?.count ?? 0
    }

    //cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CLPProfile.shared.goal(at: indexPath.row).generateCellFor(tableView, at: indexPath)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? FeedViewCell)?.showShadow()
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
}
