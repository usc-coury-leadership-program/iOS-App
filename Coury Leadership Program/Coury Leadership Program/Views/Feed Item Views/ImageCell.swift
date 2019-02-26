//
//  ImageViewCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell, FeedableCell {

    public static let HEIGHT: CGFloat = 336
    public static let REUSE_ID: String = "ImageCell"
    public static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    public static func registerWith(_ tableView: UITableView) {tableView.register(getUINib(), forCellReuseIdentifier: REUSE_ID)}
    public static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {return tableView.dequeueReusableCell(withIdentifier: REUSE_ID, for: indexPath)}

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var squareImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func onTap() {
        addInnerShadow(around: insetView.layer)
    }
    
}
