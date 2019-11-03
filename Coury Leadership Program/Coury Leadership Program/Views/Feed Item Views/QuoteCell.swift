//
//  QuoteCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class QuoteCell: AUITableViewCell, FeedViewCell {

    public static let HEIGHT: CGFloat = 186
    public static let REUSE_ID: String = "QuoteCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var favoriteHeart: UIImageView!
    
    var isSaved: Bool = false {
        didSet {favoriteHeart.image = isSaved ? #imageLiteral(resourceName: "Image") : #imageLiteral(resourceName: "Heart")}
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
        
        favoriteHeart.isUserInteractionEnabled = true
        favoriteHeart.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHeartTap(_:))))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    @objc func onHeartTap(_ sender: UITapGestureRecognizer) {
        CLPProfile.shared.toggleSavedContent(for: FeedViewController.indexPathMapping?(indexPath!) ?? indexPath!.row)
        isSaved = !isSaved
    }

    func onTap(inContext vc: UIViewController) {
    }
    func onLongPress(began: Bool) {}

    override public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        guard let quote = data as? Quote else {return self}
        quoteText.text = quote.quoteText//"“" + quoteText + "”"
        authorText.text = "- " + quote.author
        return self
    }
}
