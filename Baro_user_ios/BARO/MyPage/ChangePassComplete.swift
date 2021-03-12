//
//  ChangePassComplete.swift
//  Baro_user_ios
//
//  Created by . on 2021/01/14.
//

import UIKit

class ChangePassComplete: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pressComplete(_ sender: Any) {
        let pvc = self.presentingViewController
        self.dismiss(animated: false) {
            if (UserDefaults.standard.bool(forKey: "checkedBox") ) {
                UserDefaults.standard.removeObject(forKey: "basket")
                UserDefaults.standard.removeObject(forKey: "user_email")
                UserDefaults.standard.removeObject(forKey: "user_name")
                UserDefaults.standard.removeObject(forKey: "user_phone")
            }
            else {
                UserDefaults.resetStandardUserDefaults()
                UserDefaults.standard.removeObject(forKey: "basket")
                UserDefaults.standard.removeObject(forKey: "user_email")
                UserDefaults.standard.removeObject(forKey: "user_name")
                UserDefaults.standard.removeObject(forKey: "user_phone")
            }
            let vc = UIStoryboard.init(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "LoginPageController")
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            pvc!.present(vc, animated: true, completion: nil)
            let bottom = pvc as? BottomTabBarController
            bottom!.changeViewController(getController: "NewMainPageController", getStoryBoard: UIStoryboard(name: "NewMainPage", bundle: nil), sender: nil)
        }
    }
}
