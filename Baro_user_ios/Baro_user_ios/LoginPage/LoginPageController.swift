//
//  LoginPageController.swift
//  BARO_USER
//
//  Created by 이혜린 on 2020/10/15.
//
import UIKit
import SwiftyJSON

class LoginPageController: UIViewController {
    @IBOutlet weak var logoImage : UIImageView!
    @IBOutlet weak var bottomArea : UIView!
    
    @IBOutlet weak var phoneInput : UITextField!
    @IBOutlet weak var passwordInput:
    UITextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var registerBtn1: UILabel!
    
    @IBOutlet weak var registerBtn2: UILabel!
    @IBOutlet weak var memoryMyAccountCheckBox: UIButton!
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    let SPREF = UserDefaults()
    var remeberInfo = UserDefaults.standard
    var makeToastMessage = ToastMessage()
    
    let bottomTabBarInfo = BottomTabBarController()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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

        passwordInput.placeholder = "비밀번호를 입력하세요"
        passwordInput.borderStyle = .none
        passwordInput.isSecureTextEntry = true
        loginButton.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        registerBtn1.isUserInteractionEnabled = true
        registerBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRegister(_:))))
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
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.mainPageControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.mainPageStoryBoard
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
    }
    
    @objc func handleRegister(_ sender : UIButton) {
        self.performSegue(withIdentifier: "PhoneSendForRegister", sender: nil)
    }
    
    @objc private func handleLogin(_ sender: UIButton) {
        guard let phone = phoneInput.text else {return}
        guard let password = passwordInput.text else { return}
        let param = ["phone":"\(phone)","pass":"\(password)"]
        networkModel.post(method: .post, param: param, url: networkURL.logInURL) { (json) in
            if json["result"].boolValue {
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
                self.toMainPageUseBottomBar()
            }
            else {
                self.makeToastMessage.showToast(message: "입력정보가 틀립니다.", font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                self.remeberInfo.removeObject(forKey: "checkedBox")
                self.remeberInfo.removeObject(forKey: "rememberUser")
            }
        }
    }
}
