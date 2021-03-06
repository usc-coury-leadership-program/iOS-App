//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase

extension Posts {
    public class Image: Post {
        let reference: StorageReference
        private(set) var squareImage: UIImage?
        
        init(reference: StorageReference, uid: String) {
            self.reference = reference
            super.init(correspondingView: ImageCell.self, uid: uid)
        }
        
        public required convenience init(dbDocument: DocumentSnapshot) {
            let uid = dbDocument.documentID
            let data = dbDocument.data()!
            
            let path: String = (data["path"] as? String) ?? ""
            let reference: StorageReference = Database.storage.reference(withPath: "Feed/Images/\(path)")
            
            self.init(reference: reference, uid: uid)
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
    }
}
