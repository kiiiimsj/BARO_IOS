//
//  RegisterPageController.swift
//  BARO_USER
//
//  Created by 이혜린 on 2020/10/15.
//

import UIKit

class RegisterPageController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameInputError: UILabel!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var passInputError: UILabel!
    @IBOutlet weak var passCheckInput: UITextField!
    @IBOutlet weak var passCheckInputError: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var emailInputError: UILabel!
    @IBOutlet weak var whitePart: uiViewSetting!
    let network = CallRequest()
    let urlMaker = NetWorkURL()
    var phoneNumber : String = ""
    var marketing = false
    public lazy var restoreFrameValue : CGFloat = whitePart.frame.origin.y
    public var up = false
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutLoad()
        backBtn.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor.white
        nameInput.delegate = self
        passInput.delegate = self
        passCheckInput.delegate = self
        emailInput.delegate = self
        nameInput.addTarget(self, action: #selector(checkNameInputField), for: .editingChanged)
        passInput.addTarget(self, action: #selector(checkPassInputField), for: .editingChanged)
        passCheckInput.addTarget(self, action: #selector(checkPassInputField), for: .editingChanged)
        emailInput.addTarget(self, action: #selector(checkEmailInputField), for: .editingChanged)
        swipeRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
   
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
    }
    func insertRegisterCoupon() {
        network.get(method: .get, url: self.urlMaker.couponRegister+"phone="+phoneNumber+"&coupon_id=9") {
            json in
            if json["result"].boolValue {
                print("성공")
            }
            else {
                print("실패")
            }
        }
    }
    func insertAllForNewAlert() {
        network.post(method: .get, url: self.urlMaker.insertAllForNew+"\(phoneNumber)") {
            json in
            if json["result"].boolValue {
                print("성공")
            }
            else {
                print("실패")
            }
        }
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
//                let storyboard = UIStoryboard(name: "LoginPage", bundle: nil)
//                let vc = storyboard.instantiateViewController(identifier: "PhoneSendForRegister")
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: false)
                self.dismiss(animated: true)
                navigationController?.popToRootViewController(animated: true)
            default: break
            }
        }
    }
    @IBAction func backBtnPressed(){
        self.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func checkPassInputField() {
        let pass = passInput.text
        let passNSString = pass! as NSString
        let passCheck = passCheckInput.text
        
        if (pass == "" || pass!.count <= 4) {
            passInputError.text = "비밀번호를 4자리 이상 입력해주세요."
            passInputError.isHidden = false
        }
        else {
            passInputError.isHidden = true
            var passGetResult : NSTextCheckingResult?
            
            let passRegex = try? NSRegularExpression(pattern: "^(?=.*[0-9]+)[a-zA-Z][a-zA-Z0-9]{7,}$", options: .caseInsensitive)
            passGetResult = passRegex?.firstMatch(in: pass!, options: [], range: NSRange(location: 0, length: passNSString.length))
            let result = passGetResult?.numberOfRanges as? Int
            if(result == nil) {
                passInputError.isHidden = false
                passInputError.text = "영어와 숫자 조합으로 8글자 이상 입력해주세요."
            }
            else {
                passInputError.isHidden = true
            }
        }
        
        if (passCheck != pass) {
            passCheckInputError.isHidden = false
        }
        else {
            passCheckInputError.isHidden = true
        }
    }
    @objc func checkEmailInputField() {
        let email = emailInput.text
        let emailNSString = email! as NSString
        var emailGetResult : NSTextCheckingResult?
        
        let emailRegex = try? NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,3}$", options: .caseInsensitive)
        emailGetResult = emailRegex?.firstMatch(in: email!, options: [], range: NSRange(location: 0, length: emailNSString.length))
        let result = emailGetResult?.numberOfRanges as? Int
        if(result == nil) {
            emailInputError.isHidden = false
        }
        else {
            emailInputError.isHidden = true
        }
    }
    @IBAction func registerSend() {
        if (nameInputError.isHidden && passInputError.isHidden && passCheckInputError.isHidden && emailInputError.isHidden
                && nameInput.text != "" && passInput.text != "" && passCheckInput.text != "" && emailInput.text != "") {
            if let email = emailInput.text, let nick = nameInput.text, let pass = passInput.text {
                let param = ["phone":"\(self.phoneNumber)","email":"\(email)","pass":"\(pass)","marketing":"\(marketing)"]
                network.post(method: .post, param: param, url: self.urlMaker.signUpURL) {
                    json in
                    if json["result"].boolValue {
//                        self.performSegue(withIdentifier: "RegisterCompletePage", sender: nil)
                        self.insertRegisterCoupon()
                        self.insertAllForNewAlert()
                        let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "RegisterCompletePage") as! RegisterCompletePage
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        guard let pvc = self.presentingViewController else { return }
                        self.dismiss(animated: false){
                            pvc.present(vc, animated: false, completion: nil)
                        }
                    }
                    else {
                        let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                        dialog.message = "\(json["message"].stringValue)"
                        dialog.modalPresentationStyle = .overFullScreen
                        dialog.modalTransitionStyle = .crossDissolve
                        self.present(dialog, animated: true)
                    }
                }
            }
        }
    }
}
extension RegisterPageController : UITextFieldDelegate {
    @objc func keyboardWillAppear(noti: NSNotification) {
        if up {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                if self.whitePart.frame.origin.y == restoreFrameValue{
                self.whitePart.frame.origin.y -= keyboardHeight / 2
                    print(self.whitePart.frame.origin.y)
                }
            }
        }
    }

@objc func keyboardWillDisappear(noti: NSNotification) {
    if self.whitePart.frame.origin.y != restoreFrameValue {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.whitePart.frame.origin.y += keyboardHeight / 2
                print(self.whitePart.frame.origin.y)
            }
        }
    }

//self.view.frame.origin.y = restoreFrameValue

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.whitePart.frame.origin.y = restoreFrameValue
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.whitePart.frame.origin.y = self.restoreFrameValue
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(passCheckInput) || textField.isEqual(emailInput) {
            up = true
        }else{
            up = false
        }
        return true
    }
}
