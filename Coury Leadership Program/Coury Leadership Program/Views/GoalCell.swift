//
//  GoalCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 8/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class GoalCell: AUITableViewCell, FeedViewCell {
    
    public static let HEIGHT: CGFloat = 100
    public static let REUSE_ID: String = "GoalCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var trashIndicator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = false
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    func setSaved(to: Bool) {}
    
    func onTap(inContext vc: UIViewController) {}
    func onLongPress(began: Bool) {
        if began {
            insetView.transform = CGAffineTransform(translationX: 10.0, y: 0.0)
            trashIndicator.isHidden = false
        }else {
            insetView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            trashIndicator.isHidden = true
        }
    }
    
    override public func populatedBy(_ data: TableableCellData) -> AUITableViewCell {
        let goal = data as? Goal
        
        textView.text = goal?.text ?? ""
        strengthLabel.text = goal?.strength?.name ?? ""
        valueLabel.text = goal?.value?.name ?? ""
        
        return self
    }
}
