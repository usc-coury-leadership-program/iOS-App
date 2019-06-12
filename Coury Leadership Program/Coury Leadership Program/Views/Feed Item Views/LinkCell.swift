//
//  LinkCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell, FeedableCell {
    
    private static let BASE_THUMBNAIL_URL = "https://www.google.com/s2/favicons?domain="

    public static let HEIGHT: CGFloat = 60
    public static let REUSE_ID: String = "LinkCell"

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var savedIndicator: UIView!
    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var previewImage: UIImageView!

    var isSaved: Bool = false {
        didSet {savedIndicator.backgroundColor = isSaved ? insetView.backgroundColor : .clear}
    }
    func setSaved(to: Bool) {
        isSaved = to
    }

    var url: URL? = nil {
        didSet {

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

        savedIndicator.layer.cornerRadius = savedIndicator.bounds.width/2.0
        savedIndicator.layer.masksToBounds = true

        previewImage.layer.cornerRadius = 8
        previewImage.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }

    func onTap() {
        if url != nil {UIApplication.shared.open(url!)}
        else {print("That URL is nil and cannot be opened")}
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
