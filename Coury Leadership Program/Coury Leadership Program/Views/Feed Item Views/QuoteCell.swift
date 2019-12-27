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
    
    private var data: ContentCellData? = nil
    
    var isSaved: Bool = false {
        didSet {favoriteHeart.isSelected = isSaved}
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
        data!.toggleLike()
        isSaved = !isSaved
    }

    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {}
    func onLongPress(began: Bool) {}

    override public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        self.data = (data as! ContentCellData)
        guard let quote = data as? Quote else {return self}
        quoteText.text = quote.quoteText//"“" + quoteText + "”"
        authorText.text = quote.author
        return self
    }
}
