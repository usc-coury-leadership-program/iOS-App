//
//  LinkCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class LinkCell: AUITableViewCell, FeedViewCell {
    
    private static let BASE_THUMBNAIL_URL = "https://www.google.com/s2/favicons?domain="

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

    var url: URL? = nil {
        didSet {
            //TODO loading these images causes feed to hang. have images saved elsewhere
            headlineText.text = url?.absoluteString
            guard let urlhost = url?.host else {return}
            let thumbnailURL = URL(string: LinkCell.BASE_THUMBNAIL_URL + urlhost)
            
            do {
                let thumbnailData = try Data.init(contentsOf: thumbnailURL!)
                previewImage.image = UIImage(data: thumbnailData)
            } catch {
                print("failed to load data")
            }

            do {
                let htmlDoc = try String(contentsOf: url!)
                let range1 = htmlDoc.range(of: "<title>")
                let range2 = htmlDoc.range(of: "</title>")
                guard let start = range1, let end = range2 else {return}
                let substr = htmlDoc[start.upperBound ..< end.lowerBound]
                headlineText.text = String(substr)
            } catch {
                print("failed to get html doc")
            }
        }
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
        if url != nil {UIApplication.shared.open(url!)}
        else {print("That URL is nil and cannot be opened")}
    }
    
    func onTap(inContext vc: UIViewController, _ sender: UITapGestureRecognizer) {}

    func onLongPress(began: Bool) {}

    override public func populatedBy(_ data: TableableCellData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        self.data = data
        url = (data as? Link)?.url
        return self
    }
}
