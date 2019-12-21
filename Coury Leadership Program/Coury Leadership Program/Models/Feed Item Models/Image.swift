//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase

public class Image: ContentCellData, Hashable {
    public let CorrespondingView: TableableCell.Type = ImageCell.self

    let reference: StorageReference
    private(set) var squareImage: UIImage?
    public let uid: String
    public let shouldDisplay: Bool = true

    init(imageReference: StorageReference, uid: String) {
        self.reference = imageReference
        self.uid = uid
    }

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
    
    public static func == (lhs: Image, rhs: Image) -> Bool {return lhs.uid == rhs.uid}
    public func hash(into hasher: inout Hasher) {hasher.combine(uid)}
}






