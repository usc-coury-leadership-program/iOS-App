//
//  ImageViewCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ImageLinkCell: AUITableViewCell, FeedViewCell {

    public static let HEIGHT: CGFloat = UITableView.automaticDimension
    public static let REUSE_ID: String = "ImageLinkCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var squareImage: UIImageView!
    @IBOutlet weak var squareImageHeight: NSLayoutConstraint!
    @IBOutlet weak var favoriteHeart: UIButton!
    @IBOutlet weak var saveImageButton: UIButton!
    
    override internal var data: TableableCellData? {
        didSet {
            if let image = (data as? Posts.ImageLink)?.squareImage {
                squareImage.image = image
                let aspectRatio = min(1.0, image.size.height / image.size.width)
                let newHeight = (self.bounds.width - 32) * aspectRatio
                squareImageHeight.constant = newHeight
            }else {
                (data as? Posts.ImageLink)?.downloadImage { [weak self] image in
                    if self != nil {
                        self!.squareImage.image = image
                        let aspectRatio = min(1.0, (image?.size.height ?? 1.0) / (image?.size.width ?? 1.0))
                        let newHeight = (self!.bounds.width - 32) * aspectRatio
                        self!.squareImageHeight.constant = newHeight
                        // Calling refresh parent when the image has already been downloaded results in a really bad error
                        // Basically, it ends up telling the TableView to update itself when it's already mid-update
                        // As such, we only call it here, asynchronously
                        self!.refreshParent?()
                    }
                }
            }
        }
    }
    
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

        squareImage.layer.cornerRadius = 8
        squareImage.layer.masksToBounds = true
        
        if #available(iOS 13.0, *) {
            saveImageButton.layer.borderColor = UIColor.label.cgColor
        } else {
            // Fallback on earlier versions
            saveImageButton.layer.borderColor = UIColor.black.cgColor
            
            favoriteHeart.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            favoriteHeart.setImage(#imageLiteral(resourceName: "HeartFilled"), for: [.highlighted, .selected])
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        squareImage.image = nil
        squareImageHeight.constant = squareImage.bounds.width
    }
    
    @IBAction func onHeartTap(_ sender: UIButton) {
        CLPProfile.shared.toggleLike(data as! Posts.Post, sync: true)
        isSaved = !isSaved
    }
    
    @IBAction func onReadMoreTap(_ sender: UIButton) {
        if let url = (data as? Posts.ImageLink)?.url {UIApplication.shared.open(url)}
        else {print("Something's wrong with that link. It can't be opened")}
    }
    
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {}
    func onLongPress(began: Bool) {}
}
