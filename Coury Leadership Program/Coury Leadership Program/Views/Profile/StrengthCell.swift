//
//  StrengthCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthCell: AUICollectionViewCell, ProfileViewCell {

    public static let REUSE_ID: String = "StrengthCell"

    @IBOutlet weak var strengthName: UILabel!

    override internal var data: CollectionableCellData? {
        didSet {
            strengthName.text = (data as? Strength)?.name
        }
    }
    public var strength: Strength? {
        return data as? Strength
    }

    public var hasThisStrength: Bool = false {
        didSet {
            contentView.backgroundColor = hasThisStrength ? strength?.domain.color() : strength?.domain.color().withAlphaComponent(0.5)
            transform = hasThisStrength ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
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
}
