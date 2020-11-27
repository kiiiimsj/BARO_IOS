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
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInputError.isHidden = true
        passInputError.isHidden = true
        passCheckInputError.isHidden = true
        emailInputError.isHidden = true
        
        nameInput.addTarget(self, action: #selector(checkNameInputField), for: .editingChanged)
        passInput.addTarget(self, action: #selector(checkPassInputField), for: .editingChanged)
        passCheckInput.addTarget(self, action: #selector(checkPassInputField), for: .editingChanged)
        emailInput.addTarget(self, action: #selector(checkEmailInputField), for: .editingDidEnd)
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
    @objc
    func checkEmailInputField() {
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
        let param : [String:Any] = [:]
        network.post(method: .post, param: param, url: self.urlMaker.signUpURL) {
            json in
            if json["result"].boolValue {
                //회원가입 완료 페이지 만들기
            }
            else {
                
            }
        }
    }
}
