//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit
import Firebase

public struct Link: FeedableData {

    let url: URL
    let squareImage: UIImage

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = LinkCell.generateCellFor(tableView, at: indexPath) as! LinkCell
        cell.url = url
        //cell.previewImage.image = squareImage
        if tableView.numberOfSections != 1 {// TODO workaround to make dots only show up in feed, rather than in feed and saved VC's
            cell.isSaved = CLPUser.shared().savedContent?.contains(indexPath.row) ?? false
        }
        return cell
    }
}

public class Image: FeedableData {

    let reference: StorageReference
    private(set) var squareImage: UIImage? = nil

    init(imageReference: StorageReference) {self.reference = imageReference}

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = ImageCell.generateCellFor(tableView, at: indexPath) as! ImageCell

        downloadImage() { image in
            cell.squareImage.image = image
        }

        if tableView.numberOfSections != 1 {// TODO workaround to make dots only show up in feed, rather than in feed and saved VC's
            cell.isSaved = CLPUser.shared().savedContent?.contains(indexPath.row) ?? false
        }
        return cell
    }

//    public static func downloadImage(at reference: StorageReference, completion: @escaping (UIImage?) -> Void) {
//        reference.getData(maxSize: 1*1024*1024) { data, error in
//            if error != nil {completion(nil)}
//            completion(UIImage(data: data!))
//        }
//    }
    private func downloadImage(completion: @escaping (UIImage?) -> Void) {
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

public struct Quote: FeedableData {

    let quoteText: String
    let author: String

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = QuoteCell.generateCellFor(tableView, at: indexPath) as! QuoteCell
        cell.quoteText.text = quoteText//"“" + quoteText + "”"
        cell.authorText.text = "- " + author
        if tableView.numberOfSections != 1 {// TODO workaround to make dots only show up in feed, rather than in feed and saved VC's
            cell.isSaved = CLPUser.shared().savedContent?.contains(indexPath.row) ?? false
        }
        return cell
    }

}

//    let url = URL(string: image.url)
//
//    DispatchQueue.global().async {
//    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//    DispatchQueue.main.async {
//    imageView.image = UIImage(data: data!)
//    }
//    }

//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}
