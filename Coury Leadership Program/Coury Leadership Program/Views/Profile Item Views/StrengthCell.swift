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

    public var hasThisStrength: Bool = false {
        didSet {
            //valueName.backgroundColor = self.hasThisValue ? ValueCell.prettyBlueColor : UIColor.lightGray.withAlphaComponent(0.75)
            //contentView.layer.borderColor = self.hasThisValue ? ValueCell.prettyBlueColor.cgColor : UIColor.lightGray.withAlphaComponent(0.75).cgColor
            //contentView.layer.borderWidth = hasThisStrength ? 3 : 0
            contentView.backgroundColor = hasThisStrength ? strength?.domain.color() : strength?.domain.color().withAlphaComponent(0.5)
//            strengthName.textColor = hasThisStrength ? .white : UIColor(cgColor: contentView.layer.borderColor!)
//            contentView.backgroundColor = self.hasThisStrength ?  : UIColor.lightGray.withAlphaComponent(0.75)
        }
    }
    func setHas(to: Bool) {hasThisStrength = to}
    
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
