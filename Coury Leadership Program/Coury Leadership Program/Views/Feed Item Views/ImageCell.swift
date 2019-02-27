//
//  ImageViewCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import CoreMotion

class ImageCell: UITableViewCell, FeedableCell {

    public static let HEIGHT: CGFloat = 336
    public static let REUSE_ID: String = "ImageCell"

    private let motionManager = CMMotionManager()
    private var tapCount: Int = 0

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var squareImage: UIImageView!

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
        if tapCount == 0 {configureShadow()}
        tapCount += 1

        if tapCount%2 != 0 {
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.02
                motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                    guard let motion = motion else {return}
                    self.adjustShadow(pitch: motion.attitude.pitch, roll: motion.attitude.roll)
                    self.showShadow()
                }
            }
        }else {
            motionManager.stopDeviceMotionUpdates()
            hideShadow()
        }
    }

    func adjustShadow(pitch: Double, roll: Double) {insetView.layer.shadowOffset = CGSize(width: roll*10, height: pitch*10)}
    
}
