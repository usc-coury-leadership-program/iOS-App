//
//  QuoteCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class QuoteCell: AUITableViewCell, FeedViewCell {

    public static let HEIGHT: CGFloat = 206
    public static let REUSE_ID: String = "QuoteCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var favoriteHeart: UIButton!
    
    override internal var data: TableableCellData? {
        didSet {
            if let quote = data as? Posts.Quote {
                quoteText.text = quote.quoteText//"“" + quoteText + "”"
                authorText.text = quote.author
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = false
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = false

        quoteText.adjustsFontSizeToFitWidth = true
        
        if #available(iOS 13.0, *) {
        } else {
            // Fallback on earlier versions
            favoriteHeart.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            favoriteHeart.setImage(#imageLiteral(resourceName: "HeartFilled"), for: [.highlighted, .selected])
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    @IBAction func onHeartTap(_ sender: UIButton) {
        CLPProfile.shared.toggleLike(data as! Posts.Post, sync: true)
        isSaved = !isSaved
    }
    
    var isSaved: Bool = false {
        didSet {favoriteHeart.isSelected = isSaved}
    }
    func setSaved(to: Bool) {
        isSaved = to
    }
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {}
    func onLongPress(began: Bool) {}
}
