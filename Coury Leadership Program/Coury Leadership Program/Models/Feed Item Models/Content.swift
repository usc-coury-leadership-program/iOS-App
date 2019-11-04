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

public struct Link: TableableCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = LinkCell.self

    let url: URL
    let squareImage: UIImage
    
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
