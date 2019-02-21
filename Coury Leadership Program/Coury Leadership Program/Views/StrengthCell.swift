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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.borderColor = strengthName.backgroundColor?.cgColor
        layer.borderWidth = 3

        strengthName.adjustsFontSizeToFitWidth = true
    }
  

}
