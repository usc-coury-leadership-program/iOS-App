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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func onTap() {}
    
}
