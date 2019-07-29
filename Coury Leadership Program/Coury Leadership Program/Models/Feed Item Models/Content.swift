//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase

public class Image: TableableCellData {
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
}

public struct Link: TableableCellData {
    public let CorrespondingView: TableableCell.Type = LinkCell.self

    let url: URL
    let squareImage: UIImage
}

public struct Quote: TableableCellData {
    public let CorrespondingView: TableableCell.Type = QuoteCell.self

    let quoteText: String
    let author: String
}
