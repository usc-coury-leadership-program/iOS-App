//
//  QuoteCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class QuoteCell: AUITableViewCell, FeedViewCell {

    public static let HEIGHT: CGFloat = 156
    public static let REUSE_ID: String = "QuoteCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var savedIndicator: UIView!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var authorText: UILabel!

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

        quoteText.adjustsFontSizeToFitWidth = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }

    func onTap(inContext vc: UIViewController) {
    }
    func onLongPress(began: Bool) {
        if began {
            //insetView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0);
            insetView.transform = CGAffineTransform(translationX: 10.0, y: 0.0)
            isSaved = !isSaved
        }else {
            //insetView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0.0, 0.0, 0.0);
            insetView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }
    }

    override public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        guard let quote = data as? Quote else {return self}
        quoteText.text = quote.quoteText//"“" + quoteText + "”"
        authorText.text = "- " + quote.author
        return self
    }
}
