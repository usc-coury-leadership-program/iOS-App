//
//  CalendarCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class CalendarCell: FeedItem {

    public static let HEIGHT: CGFloat = 68
    public var calendar: Calendar? = nil {
        didSet {currentEvent = 0}
    }
    private var currentEvent: Int = 0 {
        didSet {
            guard let events = calendar?.events else {return}
            if (currentEvent < 0) {currentEvent = events.count - 1}
            let event = events[currentEvent % events.count]
            eventText.text = event.name + " @ " + event.date.description
        }
    }

    @IBOutlet weak var eventText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickPrevious(_ sender: Any) {currentEvent -= 1}

    @IBAction func onClickNext(_ sender: Any) {currentEvent += 1}
    
}
