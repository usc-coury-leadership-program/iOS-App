//
//  AddGoalViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 8/24/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cubeView: CubeView!
    internal var cubeFaces: [UIImageView] = []
    
    public static var activeValueForRecs: String = "" {
        didSet {activeRecommendations = VALUE_RECS[activeValueForRecs] ?? []}
    }
    public static var activeRecommendations: [String] = []
    
    internal var lastUpdated: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        engageTableView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCubeTap(_:)))
        cubeView.addGestureRecognizer(tap)
        
        setupCubeView()
        cubeView.enableMotion()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cubeView.needsTaring = true
        cubeView.trackMotion(true)
        
        CLPProfile.shared.onFetchSuccess {
            self.setupCubeView()
            self.updateTableView()
        }
        if CLPProfile.shared.basicInformation.lastModified > lastUpdated {
            self.setupCubeView()
            self.updateTableView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        cubeView.trackMotion(false)
    }
    
    @objc func onCubeTap(_ sender: UITapGestureRecognizer? = nil) {
        cubeView.roll(randomness: 3)
        
        let i = cubeView.topFaceIndex % CLPProfile.shared.basicInformation.values.count
        Self.activeValueForRecs = VALUE_LIST.owned[i].name
        
        self.updateTableView()
    }
    
    private func setupCubeView() {
        cubeFaces = cubeView.createFaces(in: cubeView.bounds)
        cubeView.situate(in: cubeView.bounds)
        
        let backgroundColor: UIColor?
        // cannot use ternary operator because #available is special
        if #available(iOS 13.0, *) {backgroundColor = .label} else {backgroundColor = view.backgroundColor}
        
        var images = VALUE_LIST.owned.map({$0.image})
        // one image will be duplicated because user has 5 strengths
        if images.count > 0 {images.append(images[0])}
        for i in 0..<images.count {
            cubeFaces[i].image = images[i]
            cubeFaces[i].contentMode = .scaleAspectFit
            
            cubeFaces[i].backgroundColor = backgroundColor
            
            cubeFaces[i].layer.cornerRadius = 8
            cubeFaces[i].layer.masksToBounds = true
        }
        lastUpdated = Date()
    }
}

extension AddGoalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.contains("?") {textView.clearsOnInsertion = true}
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        Self.activeRecommendations[indexPath.row] = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        textView.sizeToFit()
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension AddGoalViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets.zero
        }
    }
}
