//
//  StrengthCell.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthCell: UICollectionViewCell {

    @IBOutlet weak var strengthName: UILabel!
    @IBOutlet weak var image: UIImageView!

    static private let prettyBlueColor = UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 0.75)

    var hasThisStrength = true {
        didSet {
            strengthName.backgroundColor = self.hasThisStrength ? StrengthCell.prettyBlueColor : UIColor.lightGray
            layer.borderColor = self.hasThisStrength ? StrengthCell.prettyBlueColor.cgColor : UIColor.lightGray.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.borderWidth = 3
        strengthName.adjustsFontSizeToFitWidth = true
    }

}
