//
//  StrengthDetailViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/25/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class StrengthDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var giganticLabel: UILabel!
    @IBOutlet weak var domainText: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    
    public var strength: Strength? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headerView.leftButton.isHidden = true
        headerView.rightButton.isHidden = true
        headerView.leftButton.isEnabled = false
        headerView.rightButton.isEnabled = false
        headerView.title.text = strength?.name
        
        giganticLabel.text = String(repeating: (strength?.name ?? "") + " ", count: 60)
        giganticLabel.textColor = strength?.domain.color() ?? UIColor.lightGray
        giganticLabel.layer.borderColor = giganticLabel.textColor.cgColor

        domainText.text = "Domain: " + (strength?.domain.name() ?? "Error")
        textView.text = strength?.description

        self.view.backgroundColor = strength?.domain.color().withAlphaComponent(0.5)
    }

    @IBAction func onReadMoreButtonPress(_ sender: Any) {
        guard let gallupURL = strength?.url else {return}
        UIApplication.shared.open(URL(string: gallupURL)!)
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
