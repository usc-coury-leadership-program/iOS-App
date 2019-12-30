//
//  FeedViewInteraction.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension FeedViewController {

    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let cell = tableView.cellForRow(at: indexPath)!
                (cell as? InteractiveTableableCell)?.onTap(inContext: self, sender)
            }
        }
    }

    @IBAction func onDoubleTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {

                if indexPath.section == 2 {
                    let post = Feed.shared.posts.posts[indexPath.row]
                    CLPProfile.shared.toggleLike(post, sync: true)

                    let cell = tableView.cellForRow(at: indexPath)!
                    (cell as? FeedViewCell)?.setSaved(to: post.liked)

                    UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }
                    }, completion: nil)
                }
            }
        }
    }

    @IBAction func onLongPressGesture(_ sender: UILongPressGestureRecognizer) {}

    @IBAction func onSwipeGesture(_ sender: UISwipeGestureRecognizer) {}
}
