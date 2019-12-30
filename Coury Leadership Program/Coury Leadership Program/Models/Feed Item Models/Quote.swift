//
//  Quote.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/18/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

extension Posts {
    public class Quote: Post {
        let quoteText: String
        let author: String
        
        init(quoteText: String, author: String, uid: String) {
            self.quoteText = quoteText
            self.author = author
            
            super.init(correspondingView: QuoteCell.self, uid: uid)
        }
        
        public required convenience init(dbDocument: DocumentSnapshot) {
            let uid = dbDocument.documentID
            let data = dbDocument.data()!
            
            var author: String = "Unknown"
            var text: String = ""
            for entry in data {
                switch entry.key {
                case "author":
                    author = entry.value as! String
                case "text":
                    text = entry.value as! String
                default:
                    break
                }
            }
            
            self.init(quoteText: text, author: author, uid: uid)
        }
    }
}
