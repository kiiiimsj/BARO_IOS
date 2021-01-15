//
//  PhoneCheckForChangePW.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/16.
//

import UIKit
import FirebaseAuth

class PhoneCheckForChangePW : UIViewController {
    @IBOutlet weak var inputPin1: UITextField!
    @IBOutlet weak var inputPin2: UITextField!
    @IBOutlet weak var inputPin3: UITextField!
    @IBOutlet weak var inputPin4: UITextField!
    @IBOutlet weak var inputPin5: UITextField!
    @IBOutlet weak var inputPin6: UITextField!
    @IBOutlet weak var inputPinView: UIView!
    @IBOutlet weak var authenticationBtn: UIButton!
    var authString : String = ""
    var verificationID : String = ""
    var phoneNumber : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPin1.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin2.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin3.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin4.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin5.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        inputPin6.addTarget(self, action: #selector(self.pinInputfieldSet(_:)), for: .allEditingEvents)
        authenticationBtn.layer.cornerRadius = 15
        swipeRecognizer()
    }
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
            
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            print("gesture")
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
    @objc func pinInputfieldSet(_ textField : UITextField) {
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
                    print("authString : ", authString)
                    textField.endEditing(true)
                default :
                    print("none")
            }
        }
    }
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func pressBtn(_ sender: Any) {
        print(authString)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: self.authString)
        Auth.auth().signIn(with: credential) { authData, error in
            if ((error) != nil) {
                let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                dialog.message = "\(String(describing: error))"
                dialog.modalPresentationStyle = .overFullScreen
                dialog.modalTransitionStyle = .crossDissolve
                self.present(dialog, animated: true)
            }
            else {
                let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "SetNewPW") as! SetNewPW
//                guard self.presentingViewController != nil else { return }
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = . crossDissolve
                vc.phoneNumber = self.phoneNumber
                guard let pvc = self.presentingViewController else { return }
                self.dismiss(animated: false){
                    pvc.present(vc, animated: true, completion: nil)
                }
//                self.dismiss(animated: false){
//                    vc.modalPresentationStyle = .fullScreen
//                    vc.modalTransitionStyle = . crossDissolve
//                    vc.phoneNumber = self.phoneNumber
//                    pvc.present(vc, animated: true, completion: nil)
//                }
            }
        }
    }
}
