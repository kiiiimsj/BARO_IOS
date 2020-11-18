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
            if let param = remeberInfo.value(forKey: "remeberUser") as? [String : Any]{
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
        print("log")
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
            print("save user info : ", param)
        }
    }
    @objc private func handleRegister(_ sender: UIButton) {
        let controller = RegisterPageController()
        self.present(controller, animated: true)
    }
    @objc private func handleLogin(_ sender: UIButton) {
        guard let phone = phoneInput.text else {return}
        guard let password = passwordInput.text else { return}
        let param = ["phone":"\(phone)","pass":"\(password)"]
        print("paramLogin L ", param)
        networkModel.post(method: .post, param: param, url: networkURL.logInURL) { (json) in
            print("login :", json)
            if json["result"].boolValue {
                UserDefaults.standard.set(json["email"].stringValue, forKey: "user_email")
                UserDefaults.standard.set(json["nick"].stringValue, forKey: "user_name")
                UserDefaults.standard.set(json["phone"].stringValue, forKey: "user_phone")
                self.performSegue(withIdentifier: "BottomTabBarController", sender: nil)
            }
            else {
                self.makeToastMessage.showToast(message: "입력정보가 틀립니다.", font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 10.0)!, targetController: self)
                UserDefaults.resetStandardUserDefaults()
            }
        }
    }
}
