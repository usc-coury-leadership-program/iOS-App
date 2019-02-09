//
//  Content.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public protocol Content {

}

public struct Link: Content{
    let url: URL
    let squareImage: UIImage
}

public struct Image: Content {
    let squareImage: UIImage
}

public struct Quote: Content {
    let quoteText: String
    let emphasizedWords: [Int]
    let author: String
}
