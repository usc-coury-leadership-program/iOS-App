//
//  FeedViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engageTableView()
    }


}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {

    /*header height*/func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0}
    /*cell height  */func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return CalendarCell.HEIGHT
        case 1: return PollCell.HEIGHT
        case 2:
            let content = exampleFeed.content[indexPath.row]
            if let _ = content as? Link {return LinkCell.HEIGHT}
            else if let _ = content as? Image {return ImageCell.HEIGHT}
            else if let _ = content as? Quote {return QuoteCell.HEIGHT}
            else {return 30}

        default: return 30
        }
    }
    /*footer height*/func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}

    /*number of sections*/func numberOfSections(in tableView: UITableView) -> Int {return 3}
    /*number of rows    */func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return exampleFeed.polls.count
        case 2: return exampleFeed.content.count
        default: return 0
        }
    }

    //cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0: return exampleFeed.calendar.generateCellFor(tableView, at: indexPath)
        case 1: return exampleFeed.polls[indexPath.row].generateCellFor(tableView, at: indexPath)
        case 2: return exampleFeed.content[indexPath.row].generateCellFor(tableView, at: indexPath)

        default: fatalError("Feed's TableView has more sections than expected.")
        }
    }

    //cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? FeedableCell else {return}
        cell.onTap()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO reset tapCount on all cells
    }

    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        CalendarCell.registerWith(tableView)
        LinkCell.registerWith(tableView)
        ImageCell.registerWith(tableView)
        QuoteCell.registerWith(tableView)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)

        tableView.reloadData()
    }
}
