//
//  LinkCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import CoreMotion

class LinkCell: UITableViewCell, FeedableCell {
    private static let BASE_THUMBNAIL_URL = "https://www.google.com/s2/favicons?domain="

    public static let HEIGHT: CGFloat = 80
    public static let REUSE_ID: String = "LinkCell"

    private let motionManager = CMMotionManager()
    private var tapCount: Int = 0
    
    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    var url: URL? = nil {
        didSet {

            headlineText.text = url?.absoluteString
            guard let urlhost = url?.host else {return}
            let thumbnailURL = URL(string: LinkCell.BASE_THUMBNAIL_URL + urlhost)
            print(thumbnailURL)
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
                let substr = htmlDoc[range1!.upperBound ..< range2!.lowerBound]
                print(substr)
                headlineText.text = String(substr)
            } catch {
                print("failed to get html doc")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func onTap() {
        print("TAPPED")
        print(url)
        if url != nil {
            print(url!)
            UIApplication.shared.open(url!)}


//        if tapCount == 0 {configureShadow()}
//        tapCount += 1
//
//        if tapCount%2 != 0 {
//            if motionManager.isDeviceMotionAvailable {
//                motionManager.deviceMotionUpdateInterval = 0.02
//                motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
//                    guard let motion = motion else {return}
//                    self.adjustShadow(pitch: motion.attitude.pitch, roll: motion.attitude.roll)
//                    self.showShadow()
//                }
//            }
//        } else {
//            motionManager.stopDeviceMotionUpdates()
//            hideShadow()
//        }
    }

    func adjustShadow(pitch: Double, roll: Double) {insetView.layer.shadowOffset = CGSize(width: roll*10, height: pitch*10)}
    
}
