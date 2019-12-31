//
//  Link.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/18/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase

extension Posts {
    public class Link: Post {
        private static let BASE_THUMBNAIL_URL = "https://www.google.com/s2/favicons?domain="
        
        let url: URL
        private(set) var headline: String?
        private(set) var favicon: UIImage?
        
        init(url: URL, uid: String) {
            self.url = url
            self.headline = self.url.absoluteString
            super.init(correspondingView: LinkCell.self, uid: uid)
        }
        
        public required convenience init(dbDocument: DocumentSnapshot) {
            let uid = dbDocument.documentID
            let data = dbDocument.data()!
            
            let link: String = (data["link"] as? String) ?? "https://www.usc.edu/"
            let url: URL = URL(string: link)!

            self.init(url: url, uid: uid)
        }
        
        public func retrieveDetails(completion: @escaping (String?, UIImage?) -> Void) {
            if (headline != nil) && (favicon != nil) {completion(self.headline, self.favicon); return}

            guard let urlhost = url.host else {return}
            let faviconURL = URL(string: Link.BASE_THUMBNAIL_URL + urlhost)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let faviconData = try Data.init(contentsOf: faviconURL!)
                    self.favicon = UIImage(data: faviconData)
                } catch {
                    print("Failed to load favicon at \(faviconURL!)")
                }

                do {
                    let htmlDoc = try String(contentsOf: self.url)
                    let range1 = htmlDoc.range(of: "<title>")
                    let range2 = htmlDoc.range(of: "</title>")
                    guard let start = range1, let end = range2 else {return}
                    let substr = htmlDoc[start.upperBound ..< end.lowerBound]
                    self.headline = String(substr)
                } catch {
                    print("Failed to load html doc at \(self.url)")
                }
                
                DispatchQueue.main.async {
                    completion(self.headline, self.favicon)
                }
            }
        }
    }
}
