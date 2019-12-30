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
    
    override internal var data: TableableCellData? {
        didSet {
            if let event = (data as? Calendar)?.events.first {
                eventText.text = "\(event.name) - \(event.start.month) \(event.start.day) \(event.start.time)"
            }
        }
    }

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
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {vc.performSegue(withIdentifier: "CalendarSegue", sender: vc)}
    func onLongPress(began: Bool) {}
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        return dateFormatter.string(from: self)
    }
}
