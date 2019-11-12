//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase

public class Image: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = ImageCell.self

    let reference: StorageReference
    private(set) var squareImage: UIImage? = nil

    init(imageReference: StorageReference) {self.reference = imageReference}

    public func downloadImage(completion: @escaping (UIImage?) -> Void) {
        if self.squareImage != nil {completion(self.squareImage); return}

        reference.getData(maxSize: 1*1024*1024) { data, error in
            if error != nil {
                print("Failed to download image at " + self.reference.fullPath)
                completion(nil)
            }else {
                self.squareImage = UIImage(data: data!)
                completion(self.squareImage)
            }
        }
    }
    
    public static func == (lhs: Image, rhs: Image) -> Bool {return lhs.reference == rhs.reference}
    public func hash(into hasher: inout Hasher) {hasher.combine(reference)}
}

public class Link: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = LinkCell.self

    private static let BASE_THUMBNAIL_URL = "https://www.google.com/s2/favicons?domain="
    let url: URL
    private(set) var headline: String?
    private(set) var favicon: UIImage?
    
    init(url: URL) {self.url = url; headline = url.absoluteString}
    
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
    
    public static func == (lhs: Link, rhs: Link) -> Bool {return lhs.url == rhs.url}
    public func hash(into hasher: inout Hasher) {hasher.combine(url)}
}

public struct Quote: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = QuoteCell.self

    let quoteText: String
    let author: String
    
    public static func == (lhs: Quote, rhs: Quote) -> Bool {return (lhs.quoteText == rhs.quoteText) && (lhs.author == rhs.author)}
    public func hash(into hasher: inout Hasher) {
        hasher.combine(quoteText)
        hasher.combine(author)
    }
}

extension Array where Element == TableableCellData {
    var thatsBeenLiked: [TableableCellData] {
        return self.filter({CLPProfile.shared.hasSavedContent(for: $0)})
    }
}
