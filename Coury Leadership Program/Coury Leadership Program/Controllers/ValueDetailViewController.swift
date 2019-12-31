//
//  StrengthDetailViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 5/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ValueDetailViewController: UIViewController {

    private static let BASE_URL = "https://www.viacharacter.org/character-strengths/"

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mottoText: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var readMoreButton: UIButton!

    public var value: Value? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headerView.leftButton.isHidden = true
        headerView.rightButton.isHidden = true
        headerView.leftButton.isEnabled = false
        headerView.rightButton.isEnabled = false
        headerView.title.text = value?.shortName
        
        imageView.image = value?.image

        mottoText.text = value?.motto
        textView.text = value?.description

        self.view.backgroundColor = ValueCell.prettyBlueColor.withAlphaComponent(0.5)
    }

    @IBAction func onReadMoreButtonPress(_ sender: Any) {
        guard let valueNameNoSpaces = value?.name.replacingOccurrences(of: " ", with: "-") else {return}
        let url = URL(string: ValueDetailViewController.BASE_URL + valueNameNoSpaces)
        UIApplication.shared.open(url!)
    }
}
