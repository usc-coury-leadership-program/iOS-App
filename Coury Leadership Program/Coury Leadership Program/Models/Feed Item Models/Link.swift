//
//  Link.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/18/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public class Link: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = LinkCell.self

    private static let BASE_THUMBNAIL_URL = "https://www.google.com/s2/favicons?domain="
    
    let url: URL
    private(set) var headline: String?
    private(set) var favicon: UIImage?
    public let uid: String
    public let shouldDisplay: Bool = true
    
    init(url: URL, uid: String) {
        self.url = url
        headline = url.absoluteString
        self.uid = uid
    }
    
    public func retrieveDetails(completion: @escaping (String?, UIImage?) -> Void) {
        if (headline != nil) && (favicon != nil) {completion(self.headline, self.favicon); return}

        guard let urlhost = url.host else {return}
        let faviconURL = URL(string: Link.BASE_THUMBNAIL_URL + urlhost)
        
        do {
            let faviconData = try Data.init(contentsOf: faviconURL!)
            favicon = UIImage(data: faviconData)
        } catch {
            print("Failed to load favicon at \(faviconURL!)")
        }

        do {
            let htmlDoc = try String(contentsOf: url)
            let range1 = htmlDoc.range(of: "<title>")
            let range2 = htmlDoc.range(of: "</title>")
            guard let start = range1, let end = range2 else {return}
            let substr = htmlDoc[start.upperBound ..< end.lowerBound]
            headline = String(substr)
        } catch {
            print("Failed to load html doc at \(url)")
        }
        
        completion(headline, favicon)
    }
    
    public static func == (lhs: Link, rhs: Link) -> Bool {return lhs.uid == rhs.uid}
    public func hash(into hasher: inout Hasher) {hasher.combine(uid)}
}
