//
//  StrengthDetailViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthDetailViewController: UIViewController {

    @IBOutlet weak var strengthName: UILabel!
    @IBOutlet weak var domainText: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    
    public var strength: Strength? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        strengthName.text = strength?.name
        domainText.text = "Domain: " + (strength?.domain.name() ?? "Error")
        textView.text = strength?.description

//        headerBackgroundView.backgroundColor =
//        readMoreButton.backgroundColor = headerBackgroundView.backgroundColor
        self.view.backgroundColor = strength?.domain.color().withAlphaComponent(0.85)
        strengthName.textColor = self.view.backgroundColor ?? .black
        readMoreButton.setTitleColor(strengthName.textColor, for: .normal)
    }

    @IBAction func onReadMoreButtonPress(_ sender: Any) {
        guard let gallupURL = strength?.url else {return}
        UIApplication.shared.open(URL(string: gallupURL)!)
    }

//    @IBAction func onCloseButtonPress(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
