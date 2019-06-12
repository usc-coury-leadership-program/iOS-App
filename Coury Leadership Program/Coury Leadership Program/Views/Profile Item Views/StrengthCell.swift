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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
