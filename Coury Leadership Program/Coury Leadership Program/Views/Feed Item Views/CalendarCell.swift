//
//  CalendarCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class CalendarCell: AUITableViewCell, FeedViewCell {
    
    public static let HEIGHT: CGFloat = 84
    public static let REUSE_ID: String = "CalendarCell"

    @IBOutlet public weak var insetView: UIView!
    @IBOutlet weak var eventText: UILabel!
    
    func setSaved(to: Bool) {}

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
    
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {vc.performSegue(withIdentifier: "CalendarSegue", sender: vc)}
    func onLongPress(began: Bool) {}

    override public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        if let event = (data as! Calendar).events.first {
            eventText.text = event.name + " - " + event.start.month + " " + event.start.day + " " + event.start.time
        }
        return self
    }
    
}
