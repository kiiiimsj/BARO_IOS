//
//  PhoneCheckForRegister.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/23.
//

import UIKit
import FirebaseAuth
class PhoneCheckForRegister : UIViewController {
    @IBOutlet weak var inputPin1: UITextField!
    @IBOutlet weak var inputPin2: UITextField!
    @IBOutlet weak var inputPin3: UITextField!
    @IBOutlet weak var inputPin4: UITextField!
    @IBOutlet weak var inputPin5: UITextField!
    @IBOutlet weak var inputPin6: UITextField!
    @IBOutlet weak var inputPinView: UIView!
    @IBOutlet weak var checkPhoneAuth: UIButton!
    var UITextFieldfield : UITextField!
    var authString : String = ""
    var verificationID : String = ""
    var phoneNumber : String = ""
    var getSmsCode : String = ""
    var credential : AuthCredential?
    let bottomTabBarInfo = BottomTabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPin1.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin2.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin3.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin4.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin5.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin6.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        checkPhoneAuth.layer.cornerRadius = 15
        swipeRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
    }
    func backBtnPressed(sender : String) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RegisterPageController") as! RegisterPageController
        vc.phoneNumber = sender
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: false) {
            pvc.present(vc, animated: true)
        }
        
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
    @objc
    func pinInputfieldSet(_ textField : UITextField) {
        textField.clearsOnBeginEditing = true
        authString = ""
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
                    authString.append(inputPin1.text!)
                    authString.append(inputPin2.text!)
                    authString.append(inputPin3.text!)
                    authString.append(inputPin4.text!)
                    authString.append(inputPin5.text!)
                    authString.append(inputPin6.text!)
                    textField.endEditing(true)
                default :
                    print("none")
            }
        }
    }
    @IBAction func sendAuthNumbers() {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: self.authString)
        Auth.auth().signIn(with: credential) { authData, error in
            if ((error) != nil) {
                let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
//                dialog.message = "\(String(describing: error))"
                dialog.message = "인증번호가 일치하지 않습니다."
                dialog.modalPresentationStyle = .overFullScreen
                dialog.modalTransitionStyle = .crossDissolve
                self.present(dialog, animated: true)
            }
            else {
                self.backBtnPressed(sender: self.phoneNumber)
            }
        }
    }
    @IBAction func backBtnPressed() {
        self.dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RegisterPageController
        vc.phoneNumber = sender as! String
    }
}
