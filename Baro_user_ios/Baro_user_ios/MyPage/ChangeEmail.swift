//
//  ChangeEmail.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/26.
//

import UIKit
class ChangeEmail : UIViewController, CAAnimationDelegate {
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    @IBOutlet weak var inputNewEmail: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var changeEmailBtn: UIButton!
    @IBOutlet weak var errorAlarmText: UILabel!
    
    let regex = try? NSRegularExpression(pattern: "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$", options: .caseInsensitive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorAlarmText.isHidden = true
        inputNewEmail.placeholder = "ex)baro@baro.com"
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
    }
    @IBAction func changeEmailBtnPush() {
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        guard let email = inputNewEmail.text else {return}
        checkRegexEmail()
        let param = ["phone":"\(phone)","email":"\(email)"]
        networkModel.post(method: .put, param: param, url: networkURL.emailUpdateURL) {
            json in
            print(json)
            if json["result"].boolValue {
                
            }
            else {
                self.errorAlarmText.isHidden = false
                self.inputNewEmail.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            }
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        errorAlarmText.isHidden = true
    }
    func checkRegexEmail() {
        let text = inputNewEmail.text
        let textNSString = text! as NSString
        let checkRegexResult = regex?.matches(in: text!, options: [], range: NSRange(location: 0, length: textNSString.length))
        print(checkRegexResult)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
        
    }
    @IBAction func backbutton() {
        self.dismiss(animated: true)
    }
}
