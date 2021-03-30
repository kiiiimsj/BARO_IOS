//
//  ChangePass.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/26.
//

import UIKit
class ChangePass : UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var errorAlarmText: UILabel!
    @IBOutlet weak var enterCurrentPass: UIButton!
    @IBOutlet weak var inputNewPass: UITextField!
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor.white
        self.errorAlarmText.isHidden = true
        inputNewPass.isSecureTextEntry = true
        swipeRecognizer()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    @IBAction func gotoEnterNewPassword() {
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        guard let password = inputNewPass.text else {return}
        let param = ["phone":"\(phone)","pass":"\(password)"]
        networkModel.post(method: .post, param: param, url: networkURL.logInURL) { (json) in
            if json["result"].boolValue {
                let vc = UIStoryboard.init(name: "ChangePass", bundle: nil).instantiateViewController(withIdentifier: "ChangePass2")
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                guard let pvc = self.presentingViewController else {return}
                self.dismiss(animated: false) {
                    pvc.present(vc, animated: false, completion: nil)
                }
            }
            else {
                self.errorAlarmText.isHidden = false
                self.inputNewPass.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            }
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        errorAlarmText.isHidden = true
    }
    
    @IBAction func backbutton() {
        self.dismiss(animated: true)
    }
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
}
