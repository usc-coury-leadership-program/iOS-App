//
//  RecommendedCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 1/7/20.
//  Copyright © 2020 USC Marshall School of Business. All rights reserved.
//

import UIKit

class RecommendedCell: AUITableViewCell, TableableCell {
    
    static var HEIGHT: CGFloat = 30
    static var REUSE_ID: String = "RecommendedCell"
    
    @IBOutlet weak var textView: UITextView!
    
    var delegate: UITextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView()
        view.backgroundColor = ValueCell.prettyBlueColor
        selectedBackgroundView = view
    }
}
