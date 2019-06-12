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
    @IBOutlet weak var savedIndicator: UIView!
    @IBOutlet weak var squareImage: UIImageView!

    var isSaved: Bool = false {
        didSet {savedIndicator.backgroundColor = isSaved ? insetView.backgroundColor : .clear}
    }
    func setSaved(to: Bool) {
        isSaved = to
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = false
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = false
        
        savedIndicator.layer.cornerRadius = savedIndicator.bounds.width/2.0
        savedIndicator.layer.masksToBounds = true

        squareImage.layer.cornerRadius = 8
        squareImage.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        squareImage.image = nil
    }

    func onTap() {
    }

    func onLongPress(began: Bool) {
        if began {
            //insetView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0);
            insetView.transform = CGAffineTransform(translationX: -10.0, y: 0.0)
            isSaved = !isSaved
        }else {
            //insetView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0.0, 0.0, 0.0);
            insetView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }
    }
}
