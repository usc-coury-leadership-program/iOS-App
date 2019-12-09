//
//  CalendarViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 11/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engageTableView()
        tableView.reloadData()
    }

    func requestPermissionAndExport(event i: Int) {
        let store: EKEventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized: export(event: i, to: store)
        case .denied: print("Cannot add to calendar. Access denied")
        case .notDetermined:
            store.requestAccess(to: .event) {[weak self] (granted: Bool, error: Error?) -> Void in
                if granted {self!.export(event: i, to: store)}
                else {print("Cannot add to calendar. Access denied")}
            }
        case .restricted: print("Woops. Access is restricted?")
        @unknown default: break
        }
    }
    
    func export(event i: Int, to store: EKEventStore) {
        let event = Database.shared.calendar.events[i]
        
        let iosevent: EKEvent = EKEvent(eventStore: store)
        iosevent.title = event.name
        iosevent.startDate = event.start
        iosevent.endDate = event.end ?? Date(timeInterval: 3600, since: event.start)
//        iosevent.notes = "This is a note"
        iosevent.calendar = store.defaultCalendarForNewEvents
        
        do {try store.save(iosevent, span: .thisEvent)}
        catch let error as NSError {print("Failed to save event with error : \(error)")}
    }
}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {

    // Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    // Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Database.shared.calendar.events.count)
        return Database.shared.calendar.events.count
    }
    // Cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CalendarTableViewCell")
        
        let event = Database.shared.calendar.events[indexPath.row]
        cell.textLabel?.text = event.name + " - " + event.start.month + " " + event.start.day + " " + event.start.time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Export", handler: { (action, view, completionHandler) in
            self.requestPermissionAndExport(event: indexPath.row)
            completionHandler(true)
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    }
}
