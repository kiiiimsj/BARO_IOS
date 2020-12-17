//
//  RegisterPageController.swift
//  BARO_USER
//
//  Created by 이혜린 on 2020/10/15.
//

import UIKit

class RegisterPageController: UIViewController {
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameInputError: UILabel!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var passInputError: UILabel!
    @IBOutlet weak var passCheckInput: UITextField!
    @IBOutlet weak var passCheckInputError: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var emailInputError: UILabel!
    let network = CallRequest()
    let urlMaker = NetWorkURL()
    var phoneNumber : String = ""
    var toastMessage = ToastMessage()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInput.addTarget(self, action: #selector(checkNameInputField), for: .editingChanged)
        passInput.addTarget(self, action: #selector(checkPassInputField), for: .editingChanged)
        passCheckInput.addTarget(self, action: #selector(checkPassInputField), for: .editingChanged)
        emailInput.addTarget(self, action: #selector(checkEmailInputField), for: .editingChanged)
        swipeRecognizer()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func layoutLoad() {
        nameInput.borderStyle = .none
        passInput.borderStyle = .none
        passCheckInput.borderStyle = .none
        emailInput.borderStyle = .none
        nameInputError.isHidden = true
        passInputError.isHidden = true
        passCheckInputError.isHidden = true
        emailInputError.isHidden = true
    }
    @objc
    func checkNameInputField() {
        let name = nameInput.text
       
        if (name == "" || name!.count <= 1) {
            nameInputError.isHidden = false
        }
        else {
            nameInputError.isHidden = true
        }
    }
    @objc
    func checkPassInputField() {
        let pass = passInput.text
        let passCheck = passCheckInput.text
        
        if (pass == "" || pass!.count <= 4) {
            
            passInputError.isHidden = false
        }
        else {
            passInputError.isHidden = true
        }
        if (passCheck != pass) {
            passCheckInputError.isHidden = false
        }
        else {
            passCheckInputError.isHidden = true
        }
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
                let storyboard = UIStoryboard(name: "LoginPage", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "PhoneSendForRegister")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            default: break
            }
        }
    }
    @objc func checkEmailInputField() {
        let email = emailInput.text
        let emailNSString = email! as NSString
        var emailGetResult : NSTextCheckingResult?
        
        let emailRegex = try? NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,3}$", options: .caseInsensitive)
        emailGetResult = emailRegex?.firstMatch(in: email!, options: [], range: NSRange(location: 0, length: emailNSString.length))
        let result = emailGetResult?.numberOfRanges as? Int
        print("emailcheck :", emailGetResult?.numberOfRanges)
        if(result == nil) {
            emailInputError.isHidden = false
        }
        else {
            emailInputError.isHidden = true
        }
    }
    @IBAction func registerSend() {
        if (nameInputError.isHidden && passInputError.isHidden && passCheckInputError.isHidden && emailInputError.isHidden ) {
            if let email = emailInput.text, let nick = nameInput.text, let pass = passInput.text {
                print("email :", email, "nick :", nick, "pass : ", pass, "phone : ", self.phoneNumber)
                let param = ["phone":"\(self.phoneNumber)","email":"\(email)","nick":"\(nick)","pass":"\(pass)"]
                network.post(method: .post, param: param, url: self.urlMaker.signUpURL) {
                    json in
                    if json["result"].boolValue {
                        self.performSegue(withIdentifier: "RegisterCompletePage", sender: "")
                        
                    }
                    else {
                        self.toastMessage.showToast(message: json["message"].stringValue, font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 13.0)!, targetController: self)
                    }
                }
            }
        }
    }
}
