//
//  FeedViewInteraction.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension FeedViewController {

    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let cell = tableView.cellForRow(at: indexPath)!
                (cell as? InteractiveTableableCell)?.onTap(inContext: self)

                UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                }, completion: nil)
            }
        }
    }

    @IBAction func onLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            guard let cell = tableView.cellForRow(at: indexPath) as? InteractiveTableableCell else {return}

            switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    cell.onLongPress(began: true)
                }, completion: nil)

                if indexPath.section == 2 {CLPProfile.shared.toggleSavedContent(for: FeedViewController.indexPathMapping?(indexPath) ?? indexPath.row)}

            case .ended:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    cell.onLongPress(began: false)
                }, completion: {_ in
                    
                    if indexPath.section == 2 {
                        if self.isJustShowingSaved {
                            self.tableView.reloadSections(IndexSet(integer: 2), with: .fade)
                        }else {
                            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.333) {
                                    self.safeboxButton.transform = CGAffineTransform(rotationAngle: 10*CGFloat.pi/180.0).scaledBy(x: 1.1, y: 1.1)
                                }
                                UIView.addKeyframe(withRelativeStartTime: 0.333, relativeDuration: 0.333) {
                                    self.safeboxButton.transform = CGAffineTransform(rotationAngle: -20*CGFloat.pi/180.0).scaledBy(x: 1.3, y: 1.3)
                                }
                                UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                                    self.safeboxButton.transform = .identity
                                }
                            }, completion: nil)
                        }
                    }
                })
            
            default:
                break
            }
        }
    }

    @IBAction func onSwipeGesture(_ sender: UISwipeGestureRecognizer) {
    }
    
    @IBAction func onSafeboxButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isJustShowingSaved = sender.isSelected
        
        sender.backgroundColor = isJustShowingSaved ? .lightGray : .black
        
        UIView.animate(withDuration: 0.2) {
            sender.tintColor = sender.isSelected ? self.view.tintColor : .white
            self.view.backgroundColor = sender.isSelected ? .black : .white
        }
        
        setNeedsStatusBarAppearanceUpdate()
        tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
    
    //MARK: - convenience functions
    func setupSafeboxButton() {
//        let safeboxImage: UIImage = #imageLiteral(resourceName: "Safebox Icon")
//        let safeboxImageTinted = safeboxImage.withRenderingMode(.alwaysTemplate)
//        safeboxButton.setImage(safeboxImageTinted, for: .disabled)
//        safeboxButton.setImage(safeboxImageTinted, for: .normal)
//        safeboxButton.setImage(safeboxImageTinted, for: .highlighted)
//        safeboxButton.setImage(safeboxImageTinted, for: .selected)
        safeboxButton.tintColor = .white
        safeboxButton.showsTouchWhenHighlighted = false
    }
}
