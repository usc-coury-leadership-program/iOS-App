//
//  StrengthCell.swift
//  Coury Leadership Program
//
//  Created by Adam Egyed on 2/10/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ValueCell: AUICollectionViewCell, ProfileViewCell {

    public static let REUSE_ID: String = "ValueCell"
    public static let prettyBlueColor = UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 0.75)
    public static let darkBlueColor = UIColor(red: 21.0/255.0, green: 73.0/255.0, blue: 108.0/255.0, alpha: 0.75)

    @IBOutlet weak var valueName: UILabel!
    @IBOutlet weak var image: UIImageView!

    override internal var data: CollectionableCellData? {
        didSet {
            if let value = data as? Value {
                valueName.text = value.name
                image.image = value.image
            }
        }
    }
    public var value: Value? {
        return data as? Value
    }

    public var hasThisValue: Bool = false {
        didSet {
            transform = hasThisValue ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
            contentView.backgroundColor = hasThisValue ? ValueCell.prettyBlueColor : UIColor.lightGray.withAlphaComponent(0.5)
            valueName.backgroundColor = contentView.backgroundColor//?.withAlphaComponent(1.0)
            contentView.layer.borderWidth = hasThisValue ? 4.0 : 0.0
        }
    }
    func setHas(to: Bool) {hasThisValue = to}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.masksToBounds = false
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = ValueCell.darkBlueColor.cgColor
        //contentView.layer.borderWidth = 3

        valueName.adjustsFontSizeToFitWidth = true
    }
}
