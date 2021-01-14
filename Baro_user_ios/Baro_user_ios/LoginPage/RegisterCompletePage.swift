//
//  RegisterCompletePage.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/28.
//

import UIKit
class RegisterCompletePage : UIViewController {
    @IBOutlet weak var goToLoginPage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        goToLoginPage.layer.cornerRadius = 15
    }
    @IBAction func goLogin() {
//        let storyboard = UIStoryboard(name: "LoginPage", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "LoginPageController")
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
}
