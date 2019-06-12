//
//  StrengthCell.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ValueCell: UICollectionViewCell {

    static private let prettyBlueColor = UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 0.75)

    @IBOutlet weak var valueName: UILabel!
    @IBOutlet weak var image: UIImageView!

    public var value: Value? = nil
    public var hasThisValue: Bool = false {
        didSet {
            valueName.backgroundColor = self.hasThisValue ? ValueCell.prettyBlueColor : UIColor.lightGray.withAlphaComponent(0.75)
            layer.borderColor = self.hasThisValue ? ValueCell.prettyBlueColor.cgColor : UIColor.lightGray.withAlphaComponent(0.75).cgColor

//            transform = self.hasThisStrength ? CGAffineTransform(scaleX: 1.01, y: 1.01) : CGAffineTransform.identity
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.borderWidth = 3

        valueName.adjustsFontSizeToFitWidth = true
        hasThisValue = false
    }

}
