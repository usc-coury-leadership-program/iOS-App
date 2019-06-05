//
//  ImageViewCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell, FeedableCell {

    public static let HEIGHT: CGFloat = 336
    public static let REUSE_ID: String = "ImageCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var squareImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
        showShadow()
    }

    func onTap() {
    }
}
