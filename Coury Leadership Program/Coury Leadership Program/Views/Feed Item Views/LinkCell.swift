//
//  LinkCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class LinkCell: AUITableViewCell, FeedViewCell {

    public static let HEIGHT: CGFloat = 120
    public static let REUSE_ID: String = "LinkCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var favoriteHeart: UIImageView!
    
    private var data: TableableCellData? = nil
    
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

        previewImage.layer.cornerRadius = 8
        previewImage.layer.masksToBounds = true
        
        favoriteHeart.isUserInteractionEnabled = true
        favoriteHeart.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHeartTap(_:))))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    @objc func onHeartTap(_ sender: UITapGestureRecognizer) {
        CLPProfile.shared.toggleSavedContent(for: self.data!)
        isSaved = !isSaved
    }
    
    @IBAction func onReadMoreTap(_ sender: UIButton) {
        if let url = (data as? Link)?.url {UIApplication.shared.open(url)}
        else {print("Something's wrong with that link. It can't be opened")}
    }
    
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {}
    func onLongPress(began: Bool) {}

    override public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        self.data = data
        (data as? Link)?.retrieveDetails {headline, image in
            self.headlineText.text = headline
            self.previewImage.image = image
        }
        return self
    }
}
