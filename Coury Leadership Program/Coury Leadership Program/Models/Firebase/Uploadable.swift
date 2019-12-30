//
//  Uploadable.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/29/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public protocol Uploadable {
    var uploadPath: String { get }
    
    func inject(into dbDocument: DocumentReference)
    func startUploading()
}

extension Uploadable {
    public func startUploading() {
        Database2.shared.upload(self)
    }
}
