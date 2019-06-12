//
//  StrengthCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthCell: UICollectionViewCell, ProfilableCell {

    public static let REUSE_ID: String = "StrengthCell"

    @IBOutlet weak var strengthName: UILabel!

    public var strength: Strength? = nil

    public var hasThisValue: Bool = false {
        didSet {
            //            transform = self.hasThisStrength ? CGAffineTransform(scaleX: 1.01, y: 1.01) : CGAffineTransform.identity
        }
    }
    func setHas(to: Bool) {hasThisValue = to}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.masksToBounds = false
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16

        strengthName.adjustsFontSizeToFitWidth = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }

}
