//
//  LoginPageController.swift
//  BARO_USER
//
//  Created by 이혜린 on 2020/10/15.
//
import UIKit
import SwiftyJSON
import KituraWebSocketClient

class LoginPageController: UIViewController {
    @IBOutlet weak var logoImage : UIImageView!
    @IBOutlet weak var bottomArea : UIView!
    
    @IBOutlet weak var phoneInput : UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var registerBtn1: UILabel!
    
    @IBOutlet weak var registerBtn2: UILabel!
    @IBOutlet weak var memoryMyAccountCheckBox: UIButton!
    @IBOutlet weak var findPasswordText: UIButton!
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    let SPREF = UserDefaults()
    var remeberInfo = UserDefaults.standard
    
    let bottomTabBarInfo = BottomTabBarController()
    var sendMessage = SendMessage()
    public var restoreFrameValue : CGFloat = 0.0
    public var up = false
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
    override func viewDidLoad() {
        super.viewDidLoad()
        if(remeberInfo.bool(forKey: "checkedBox")) {
            memoryMyAccountCheckBox.isSelected = true
            if let param = remeberInfo.value(forKey: "rememberUser") as? [String : Any]{
                phoneInput.text = "\(param["phone"] as! String)"
                passwordInput.text = "\(param["pass"] as! String)"
            }
        }
        
        phoneInput.placeholder = "01012345678"
        phoneInput.borderStyle = .none
        phoneInput.delegate = self

        passwordInput.delegate = self
        passwordInput.placeholder = "비밀번호를 입력하세요"
        passwordInput.borderStyle = .none
        passwordInput.isSecureTextEntry = true
        loginButton.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        registerBtn2.isUserInteractionEnabled = true
        registerBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRegister(_:))))
    }
    @IBAction func rememberUserInfo() {
        if(memoryMyAccountCheckBox.isSelected) {
            memoryMyAccountCheckBox.isSelected = false
            UserDefaults.resetStandardUserDefaults()
            return
        }
        else {
            memoryMyAccountCheckBox.isSelected = true
            guard let phone = phoneInput.text else {return}
            guard let password = passwordInput.text else { return}
            let param = ["phone":"\(phone)","pass":"\(password)"]
            remeberInfo.set(param, forKey: "rememberUser")
            remeberInfo.set(true, forKey: "checkedBox")
        }
    }
    
    func toMainPageUseBottomBar() {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        //        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.mainPageControllerIdentifier
        //        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.mainPageStoryBoard
                ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.newMainPageControllerIdentifier
                ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.newMainPageStoryBoard
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
    }
    @objc func handleRegister(_ sender : UIButton) {
        self.performSegue(withIdentifier: "BeforeRegister", sender: nil)
    }
    
    @objc private func handleLogin(_ sender: UIButton) {
        guard let phone = phoneInput.text else {return}
        guard let password = passwordInput.text else { return}
        let param = ["phone":"\(phone)","pass":"\(password)"]
        networkModel.post(method: .post, param: param, url: networkURL.logInURL) { (json) in
            if json["result"].boolValue {
                UserDefaults.standard.set("", forKey: "basket")
                UserDefaults.standard.set("", forKey: "currentStoreId")
                UserDefaults.standard.set(json["email"].stringValue, forKey: "user_email")
                UserDefaults.standard.set(json["nick"].stringValue, forKey: "user_name")
                UserDefaults.standard.set(json["phone"].stringValue, forKey: "user_phone")
                UserDefaults.standard.removeObject(forKey: "basket")
                if(self.memoryMyAccountCheckBox.isSelected) {
                    self.remeberInfo.set(param, forKey: "rememberUser")
                    self.remeberInfo.set(true, forKey: "checkedBox")
                }
                else {
                    self.remeberInfo.removeObject(forKey: "checkedBox")
                    self.remeberInfo.removeObject(forKey: "rememberUser")
                }
                self.dismiss(animated: false)
            }
            else {
                let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                dialog.message = "비밀번호 혹은 아이디가 틀립니다."
                dialog.modalPresentationStyle = .overFullScreen
                dialog.modalTransitionStyle = .crossDissolve
                self.present(dialog, animated: true) {
                    self.remeberInfo.removeObject(forKey: "checkedBox")
                    self.remeberInfo.removeObject(forKey: "rememberUser")
                }
            }
        }
    }

    @IBAction func clickFindPassword(_ sender: Any) {
        let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "FindPassWord") as! FindPassWord
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = . crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

extension LoginPageController : UITextFieldDelegate {
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
        if textField.isEqual(passwordInput) {
            up = true
        }else{
            up = false
        }
        return true
    }
}
