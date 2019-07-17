//
//  PollCellAnswerCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/14/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class PollCellAnswerCell: UICollectionViewCell {

    public static let REUSE_ID: String = "PollCellAnswerCell"

    @IBOutlet weak var answerText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height/2.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
    }

    //MARK: - convenience functions
    static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    static func registerWith(_ collectionView: UICollectionView) {collectionView.register(getUINib(), forCellWithReuseIdentifier: REUSE_ID)}
    static func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_ID, for: indexPath)
    }

}
