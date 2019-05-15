//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Link: FeedableData {

    let url: URL
    let squareImage: UIImage

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = LinkCell.generateCellFor(tableView, at: indexPath) as! LinkCell
        cell.url = url
        //cell.previewImage.image = squareImage
        return cell
    }
}

public struct Image: FeedableData {

    let squareImage: UIImage

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = ImageCell.generateCellFor(tableView, at: indexPath) as! ImageCell
        cell.squareImage.image = squareImage
        return cell
    }

}

public struct Quote: FeedableData {

    let quoteText: String
    let author: String

    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = QuoteCell.generateCellFor(tableView, at: indexPath) as! QuoteCell
        cell.quoteText.text = quoteText + " - " + author
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
