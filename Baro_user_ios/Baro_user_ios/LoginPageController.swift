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
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
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

    }
    
    @objc private func handleRegister(_ sender: UIButton) {
        let controller = RegisterPageController()
        self.present(controller, animated: true)
    }
    @objc private func handleLogin(_ sender: UIButton) {
//        guard let phone = userPhoneInputField.text else {return}
//        guard let password = userPasswordInputField.text else { return}
//        let param = ["phone":"\(phone)","pass":"\(password)"]
//
//        networkModel.post(method: .post, param: param, url: networkURL.logInURL) { (json) in
//            print(json)
//            if json["result"].boolValue {
//                self.sucessLogin()
//            }
//        }
    }
    @objc func sucessLogin() {
        //let controller = MainPageController()
        //self.present(controller, animated: true)
    }
    
}
