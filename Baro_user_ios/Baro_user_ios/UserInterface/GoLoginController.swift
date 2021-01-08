//
//  GoLoginController.swift
//  Baro_user_ios
//
//  Created by . on 2021/01/04.
//

import UIKit

class GoLoginController: UIViewController {
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var window: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.borderWidth = 2
        loginBtn.layer.cornerRadius = 10
        loginBtn.layer.borderColor = UIColor.white.cgColor
        window.layer.cornerRadius = 20
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel(_:))))
    }
    @IBAction func clickLogin(_ sender: Any) {
        let vc = UIStoryboard.init(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "LoginPageController")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        guard let pvc = self.presentingViewController else{
            return
        }
        self.dismiss(animated: false) {
            pvc.present(vc, animated: false, completion: nil)
        }
        
    }
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @objc func cancel(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
}
