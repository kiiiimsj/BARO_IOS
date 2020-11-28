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
    @IBAction func goToLogin() {
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: true) {
            pvc.performSegue(withIdentifier: "LoginPageController", sender: nil)
        }
        
    }
}
