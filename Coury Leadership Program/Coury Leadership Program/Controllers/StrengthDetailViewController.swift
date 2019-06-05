//
//  StrengthDetailViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 5/28/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthDetailViewController: UIViewController {

    private static let BASE_URL = "https://www.viacharacter.org/www/Character-Strengths/"

    @IBOutlet weak var strengthName: UILabel!
    @IBOutlet weak var mottoText: UITextView!
    @IBOutlet weak var textView: UITextView!

    public var strength: Strength? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        strengthName.text = strength?.shortName()
        mottoText.text = strength?.motto
        textView.text = strength?.description
    }

    @IBAction func onReadMoreButtonPress(_ sender: Any) {
        guard let strengthNameNoSpaces = strength?.name.replacingOccurrences(of: " ", with: "-") else {return}
        let url = URL(string: StrengthDetailViewController.BASE_URL + strengthNameNoSpaces)
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
