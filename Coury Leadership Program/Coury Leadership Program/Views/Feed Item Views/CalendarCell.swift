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

    public var calendar: Calendar? = nil {
        didSet {currentEvent = 0}
    }
    private var currentEvent: Int = 0 {
        didSet {
            guard let events = calendar?.events, events.count > 0 else {return}
            if (currentEvent < 0) {currentEvent = events.count - 1}
            let event = events[currentEvent % events.count]
            eventText.text = event.name + " - " + event.date.month + " " + event.date.day + " " + event.date.time
        }
    }

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

    func onTap(inContext vc: UIViewController) {currentEvent += 1}
    func onLongPress(began: Bool) {}


    override public func populatedBy(_ data: TableableCellData) -> AUITableViewCell {
        calendar = data as? Calendar
        return self
    }
    
}
