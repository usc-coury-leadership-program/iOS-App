//
//  StrengthCell.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthCell: UICollectionViewCell {

    static private let prettyBlueColor = UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 0.75)

    @IBOutlet weak var strengthName: UILabel!
    @IBOutlet weak var image: UIImageView!

    public var strength: Strength? = nil
    public var hasThisStrength: Bool = false {
        didSet {
            strengthName.backgroundColor = self.hasThisStrength ? StrengthCell.prettyBlueColor : UIColor.lightGray
            layer.borderColor = self.hasThisStrength ? StrengthCell.prettyBlueColor.cgColor : UIColor.lightGray.cgColor

//            transform = self.hasThisStrength ? CGAffineTransform(scaleX: 1.01, y: 1.01) : CGAffineTransform.identity
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.borderWidth = 3

        strengthName.adjustsFontSizeToFitWidth = true
        hasThisStrength = false
    }

}
