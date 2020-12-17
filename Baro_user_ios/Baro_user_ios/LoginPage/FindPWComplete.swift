//
//  FindPWComplete.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/16.
//

import UIKit

class FindPWComplete: UIViewController {
    @IBOutlet weak var goLoginPage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pressGoLogin(_ sender: Any) {
        let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "LoginPageController") as! LoginPageController
        guard let pvc = self.presentingViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = . crossDissolve
//        self.present(vc, animated: true, completion: nil)
        self.dismiss(animated: false, completion: nil)
//        self.dismiss(animated: false){
//            self.present(vc, animated: true, completion: nil)
//        }
        
    }
}
