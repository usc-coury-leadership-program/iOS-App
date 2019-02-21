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

//    //header title
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return nil
//    }
//    //header view
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let headerView = view as? UITableViewHeaderFooterView else {return}
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .clear
//        headerView.backgroundView = backgroundView
//    }

    //cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.calendar = exampleFeed.calendar
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as! PollCell
            cell.questionText.text = exampleFeed.polls[indexPath.row].question
            return cell
        case 2:
            let content = exampleFeed.content[indexPath.row]

            if let content = content as? Link {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.headlineText.text = content.url.absoluteString
                cell.previewImage.image = content.squareImage
                return cell
            }else if let content = content as? Image {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
                cell.squareImage.image = content.squareImage
                return cell
            }else if let content = content as? Quote {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
                cell.quoteText.text = content.quoteText + " - " + content.author
                return cell
            }else {
                fatalError("Content type cannot be displayed because it's not associated with a cell xib!")
            }

        default: fatalError("Feed's TableView has more sections than expected.")
        }
    }

    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
        tableView.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.register(UINib(nibName: "QuoteCell", bundle: nil), forCellReuseIdentifier: "QuoteCell")
        tableView.reloadData()
    }
}

