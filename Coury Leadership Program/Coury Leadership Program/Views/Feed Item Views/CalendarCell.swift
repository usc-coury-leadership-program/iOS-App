//
//  CalendarCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell, FeedableCell {
    
    public static let HEIGHT: CGFloat = 84
    public static let REUSE_ID: String = "CalendarCell"
    public static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    public static func registerWith(_ tableView: UITableView) {tableView.register(getUINib(), forCellReuseIdentifier: REUSE_ID)}
    public static func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {return tableView.dequeueReusableCell(withIdentifier: REUSE_ID, for: indexPath)}

    public var calendar: Calendar? = nil {
        didSet {currentEvent = 0}
    }
    private var currentEvent: Int = 0 {
        didSet {
            guard let events = calendar?.events else {return}
            if (currentEvent < 0) {currentEvent = events.count - 1}
            let event = events[currentEvent % events.count]
            eventText.text = event.name + " - " + event.date.month + " " + event.date.day + " " + event.date.time
        }
    }

    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var eventText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = true
        insetView.layer.borderColor = UIColor.gray.cgColor
        insetView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickPrevious(_ sender: Any) {currentEvent -= 1}

    @IBAction func onClickNext(_ sender: Any) {currentEvent += 1}

    func onTap() {
        addInnerShadow(around: insetView.layer)
        eventText.addInnerShadow()
    }
    
}
