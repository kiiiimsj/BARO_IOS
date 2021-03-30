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
        backBtn.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor.white
        errorAlarmText.isHidden = true
        inputNewEmail.placeholder = "ex)baro@baro.com"
        swipeRecognizer()
    }
    @IBAction func changeEmailBtnPush() {
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        guard let email = inputNewEmail.text else {return}
        checkRegexEmail()
        let param = ["phone":"\(phone)","email":"\(email)"]
        networkModel.post(method: .put, param: param, url: networkURL.emailUpdateURL) {
            json in
            if json["result"].boolValue {
                UserDefaults.standard.set(self.inputNewEmail.text, forKey: "user_email")
                let vc = UIStoryboard.init(name: "ChangeEmail", bundle: nil).instantiateViewController(withIdentifier: "ChangeEmailComplete")
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                guard let pvc = self.presentingViewController else {return}
                self.dismiss(animated: false) {
                    pvc.present(vc, animated: false, completion: nil)
                }
                
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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
        
    }
    @IBAction func backbutton() {
        self.dismiss(animated: true)
    }
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
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
}
