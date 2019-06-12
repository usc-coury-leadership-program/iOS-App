//
//  StrengthDetailViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 5/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class ValueDetailViewController: UIViewController {

    private static let BASE_URL = "https://www.viacharacter.org/www/Character-Strengths/"

    @IBOutlet weak var valueName: UILabel!
    @IBOutlet weak var mottoText: UITextView!
    @IBOutlet weak var textView: UITextView!

    public var value: Value? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        valueName.text = value?.shortName()
        mottoText.text = value?.motto
        textView.text = value?.description
    }

    @IBAction func onReadMoreButtonPress(_ sender: Any) {
        guard let valueNameNoSpaces = value?.name.replacingOccurrences(of: " ", with: "-") else {return}
        let url = URL(string: ValueDetailViewController.BASE_URL + valueNameNoSpaces)
        UIApplication.shared.open(url!)
    }

    @IBAction func onCloseButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
