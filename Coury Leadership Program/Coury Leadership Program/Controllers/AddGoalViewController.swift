//
//  AddGoalViewController.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 8/24/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var strengthPicker: UIPickerView!
    @IBOutlet weak var valuePicker: UIPickerView!
    
    private static let PLACEHOLDER = "Enter a goal here."
    
    private let strengthPickerHooks = ArrayPickerHooks(STRENGTH_LIST)
    private let valuePickerHooks = ArrayPickerHooks(VALUE_LIST)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = AddGoalViewController.PLACEHOLDER
        textView.delegate = self
        textView.becomeFirstResponder()
        
        strengthPicker.delegate = strengthPickerHooks
        strengthPicker.dataSource = strengthPickerHooks
        strengthPicker.layer.cornerRadius = 16
        
        valuePicker.delegate = valuePickerHooks
        valuePicker.dataSource = valuePickerHooks
        valuePicker.layer.cornerRadius = 16
    }

}

extension AddGoalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == AddGoalViewController.PLACEHOLDER {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

private class ArrayPickerHooks: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private let array: Array<Named>
    
    init(_ array: Array<Named>) {
        self.array = array
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "None" : array[row - 1].name
    }
}
