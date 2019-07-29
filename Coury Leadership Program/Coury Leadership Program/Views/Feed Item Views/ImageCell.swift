//
//  ImageViewCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ImageCell: AUITableViewCell, FeedViewCell {

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

    func onTap(inContext vc: UIViewController) {
        let alert = UIAlertController(title: "Do you want to save this wallpaper to your Camera Roll?", message: "You can also long press on the image to bookmark it within the app.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            guard let imageToSave = self.squareImage.image else {return}
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true)
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

    override public func populatedBy(_ data: TableableCellData) -> AUITableViewCell {
        (data as? Image)?.downloadImage {image in
            self.squareImage.image = image
        }
        return self
    }
}
