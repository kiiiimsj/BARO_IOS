//
//  ChangeEmail.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/26.
//

import UIKit
class ChangeEmail : UIViewController, CAAnimationDelegate {
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    @IBOutlet weak var inputNewEmail: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var changeEmailBtn: UIButton!
    @IBOutlet weak var errorAlarmText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorAlarmText.isHidden = true
        inputNewEmail.placeholder = "ex)baro@baro.com"
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
    }
    @IBAction func changeEmailBtnPush() {
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        let email = inputNewEmail.text
        let param = ["phone":"\(phone)","email":"\(email)"]
        networkModel.post(method: .put, param: param, url: networkURL.emailUpdateURL) {
            json in
            if json["result"].boolValue {
                
            }
            else {
                
            }
        }
    }
    @IBAction func backbutton() {
        self.performSegue(withIdentifier: "MyPageController", sender: nil)
    }
}
