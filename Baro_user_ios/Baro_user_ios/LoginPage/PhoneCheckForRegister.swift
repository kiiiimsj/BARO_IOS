//
//  PhoneCheckForRegister.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/23.
//

import UIKit
class PhoneCheckForRegister : UIViewController {
    @IBOutlet weak var inputPin1: UITextField!
    @IBOutlet weak var inputPin2: UITextField!
    @IBOutlet weak var inputPin3: UITextField!
    @IBOutlet weak var inputPin4: UITextField!
    @IBOutlet weak var inputPin5: UITextField!
    @IBOutlet weak var inputPin6: UITextField!
    @IBOutlet weak var inputPinView: UIView!
    @IBOutlet weak var checkPhoneAuth: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPin1.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin2.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin3.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin4.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin5.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin6.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
    }
    
    @objc
    func pinInputfieldSet(_ textField : UITextField) {
        textField.clearsOnBeginEditing = true
        if(textField.text!.count >= 1) {
            switch(textField.tag) {
                case 1:
                    self.inputPin2.becomeFirstResponder()
                case 2:
                    self.inputPin3.becomeFirstResponder()
                case 3:
                    self.inputPin4.becomeFirstResponder()
                case 4:
                    self.inputPin5.becomeFirstResponder()
                case 5:
                    self.inputPin6.becomeFirstResponder()
                case 6:
                    textField.endEditing(true)
                default :
                    print("none")
            }
        }
    }
}
