//
//  ChangePass2.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/28.
//

import UIKit
class ChangePass2 : UIViewController {
    
    @IBOutlet weak var errorAlarmText1: UILabel!
    @IBOutlet weak var errorAlarmText2: UILabel!
    @IBOutlet weak var inputNewPass: UITextField!
    @IBOutlet weak var checkNewPass: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    var flag : Int = 0
    public var restoreFrameValue : CGFloat = 0.0
    public var up = false
//    let regex = try? NSRegularExpression(pattern:"[0-9a-zA-Z]{4,}$", options: .caseInsensitive)
    
    let regex = try? NSRegularExpression(pattern:"(([a-zA-Z]|[0-9])+([0-9]|[a-zA-Z])){4,}", options: .caseInsensitive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorAlarmText1.isHidden = true
        errorAlarmText2.isHidden = true
        inputNewPass.isSecureTextEntry = true
        checkNewPass.isSecureTextEntry = true
        inputNewPass.delegate = self
        checkNewPass.delegate = self
        backBtn.setImage(UIImage(named: "arrow_left"), for: .normal)
        swipeRecognizer()
        self.inputNewPass.addTarget(self, action: #selector(self.textFieldDidChange1(textField:)), for: .editingChanged)
        self.checkNewPass.addTarget(self, action: #selector(self.textFieldDidChange2(textField:)), for: .editingChanged)
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
    @IBAction func sendNewPassToServer() {
        if (inputNewPass.text != "" && checkNewPass.text != "" && errorAlarmText1.isHidden && errorAlarmText2.isHidden){
            let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
            guard let password = inputNewPass.text else {return}
            let param = ["phone":"\(phone)","pass":"\(password)"]
            networkModel.post(method: .put, param: param,url: networkURL.passwordUpdateURL) {
                json in
                if json["result"].boolValue {
                    let vc = UIStoryboard.init(name: "ChangePass", bundle: nil).instantiateViewController(withIdentifier: "ChangePassComplete")
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    guard let pvc = self.presentingViewController else {return}
                    self.dismiss(animated: false) {
                        pvc.present(vc, animated: false, completion: nil)
                    }
                }
                else {
                    print("비밀번호 변경 실패")
                }
            }
        }
    }
    func checkPassVaild() {
        guard let newPass = inputNewPass.text else { return }
        guard let checkPass = checkNewPass.text else {return}
        let passVaild = regex?.matches(in: newPass, options: [], range: NSRange(location: 0, length: newPass.count))
        if (passVaild?.count == 1) {
            if (newPass != checkPass){
                self.errorAlarmText2.isHidden = false
                self.checkNewPass.addTarget(self, action: #selector(self.textFieldDidChange2(textField:)), for: .editingChanged)
            }
            else {
                flag = 1
            }
        }
        else {
            self.errorAlarmText1.isHidden = false
            self.inputNewPass.addTarget(self, action: #selector(self.textFieldDidChange1(textField:)), for: .editingChanged)
        }
    }
    
    @objc func textFieldDidChange1(textField: UITextField){
        let pass = inputNewPass.text
        let passNSString = pass! as NSString
        
        if (pass == "" || pass!.count <= 4) {
            errorAlarmText1.text = "비밀번호를 4자리 이상 입력해주세요."
            errorAlarmText1.isHidden = false
        }
        else {
            let passVaild = regex?.firstMatch(in: pass!, options: [], range: NSRange(location: 0, length: pass!.count))
            let result = passVaild?.numberOfRanges as? Int
            if (result == nil) {
                errorAlarmText1.isHidden = false
                errorAlarmText1.text = "영어 와 숫자 조합으로 8글자 이상 입력해주세요."
            }
            else {
                errorAlarmText1.isHidden = true
            }
        }
    }
    @objc func textFieldDidChange2(textField: UITextField){
        if (inputNewPass.text != checkNewPass.text) {
            errorAlarmText2.isHidden = false
        }
        else {
            errorAlarmText2.isHidden = true
        }
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

extension ChangePass2 : UITextFieldDelegate {
    @objc func keyboardWillAppear(noti: NSNotification) {
        if up {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                if self.view.frame.origin.y == restoreFrameValue{
                self.view.frame.origin.y -= keyboardHeight
                }
            }
        }
    }

    @objc func keyboardWillDisappear(noti: NSNotification) {
        if self.view.frame.origin.y != restoreFrameValue {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
            }
        }
    }

//self.view.frame.origin.y = restoreFrameValue

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = restoreFrameValue
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = self.restoreFrameValue
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(checkNewPass) {
            up = true
        }else{
            up = false
        }
        return true
    }
}
