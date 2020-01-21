//
//  AddGoalViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 8/24/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var promptView: UITextView!
    @IBOutlet weak var goalWritingView: UITextView!
    
    @IBOutlet weak var opaqueView: UIView!
    @IBOutlet weak var opaqueViewYPosition: NSLayoutConstraint!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        opaqueView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCubeTap(_:)))
        cubeView.addGestureRecognizer(tap)
        setupCubeView()
        cubeView.enableMotion()
        
        goalWritingView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goalWritingView.becomeFirstResponder()
        
        cubeView.needsTaring = true
        cubeView.trackMotion(true)
        
        CLPProfile.shared.onFetchSuccess {
            self.setupCubeView()
            self.onCubeTap()
        }
        if CLPProfile.shared.basicInformation.lastModified > lastUpdated {
            self.setupCubeView()
            self.onCubeTap()
        }
        self.onCubeTap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        goalWritingView.resignFirstResponder()
        cubeView.trackMotion(false)
    }
    
    @IBAction func onModalViewTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onCubeTap(_ sender: UITapGestureRecognizer? = nil) {
        cubeView.roll(randomness: 3)
        
        if CLPProfile.shared.basicInformation.values.count > 0 {
            let i = cubeView.topFaceIndex % CLPProfile.shared.basicInformation.values.count
            Self.activeValueForRecs = VALUE_LIST.owned[i].name
            
            updatePrompt()
        }
    }
    
    private func updatePrompt() {
        let prompt = Self.activeRecommendations.randomElement() ?? "What's something you've always wanted to do?"
        if prompt.contains("?") {
            promptView.text = prompt
            goalWritingView.text = ""
        }else {
            promptView.text = "Personalize the given goal. It will be easier to accomplish if it's more specific."
            goalWritingView.text = prompt
        }
        
//        if !goalWritingView.isFirstResponder {
//            goalWritingView.textColor = .lightGray
//        }
    }
    
    private func setupCubeView() {
        cubeFaces = cubeView.createFaces(in: cubeView.bounds)
        cubeView.situate(in: cubeView.bounds)
        
        let backgroundColor: UIColor?
        // cannot use ternary operator because #available is special
        if #available(iOS 13.0, *) {backgroundColor = .label} else {backgroundColor = .black}
        
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
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }
}

extension AddGoalViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.opaqueViewYPosition.constant = keyboardSize.height
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.opaqueViewYPosition.constant = 0
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
