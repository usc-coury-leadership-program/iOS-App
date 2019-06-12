//
//  PollCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class PollCell: UITableViewCell, FeedableCell {

    public static let HEIGHT: CGFloat = 216
    public static let REUSE_ID: String = "PollCell"
    
    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var questionText: UILabel!

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

    func onTap() {}
    func onLongPress(began: Bool) {}
    
}
