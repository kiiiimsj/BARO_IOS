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
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    let SPREF = UserDefaults()
    
    let registerButton: UIButton = {
        let registerBtn = UIButton()
        registerBtn.backgroundColor = .white
        registerBtn.setTitle("회원가입", for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        registerBtn.tintColor = .purple
        registerBtn.addTarget(self, action: #selector(handleRegister(_:)), for: .touchUpInside)
        return registerBtn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneInput.placeholder = "01012345678"
        phoneInput.borderStyle = .none

        passwordInput.placeholder = "비밀번호를 입력하세요"
        passwordInput.borderStyle = .none
        passwordInput.isSecureTextEntry = true
        loginButton.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        print("log")
    }
    
    @objc private func handleRegister(_ sender: UIButton) {
        let controller = RegisterPageController()
        self.present(controller, animated: true)
    }
    @objc private func handleLogin(_ sender: UIButton) {
        guard let phone = phoneInput.text else {return}
        guard let password = passwordInput.text else { return}
        let param = ["phone":"\(phone)","pass":"\(password)"]
        networkModel.post(method: .post, param: param, url: networkURL.logInURL) { (json) in
            print(json)
            if json["result"].boolValue {
                UserDefaults.standard.set(json["email"].stringValue, forKey: "user_email")
                UserDefaults.standard.set(json["nick"].stringValue, forKey: "user_name")
                UserDefaults.standard.set(json["phone"].stringValue, forKey: "user_phone")
                //self.sucessLogin()
                self.performSegue(withIdentifier: "LoginToMyPage", sender: nil)
            }
        }
    }
    func sucessLogin() {
//        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MyPageController")
//        vcName?.modalTransitionStyle = .coverVertical
//        self.present(vcName!, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let myPageViewController = segue.destination as? MyPageController else {return}
    }
    
}
