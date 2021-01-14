//
//  ChangePass2.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/28.
//

import UIKit
class ChangePass2 : UIViewController {
    
    @IBOutlet weak var errorAlarmText1: UILabel!
    @IBOutlet weak var errorAlarmText2: UILabel!
    @IBOutlet weak var inputNewPass: UITextField!
    @IBOutlet weak var checkNewPass: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    var flag : Int = 0
    
    let regex = try? NSRegularExpression(pattern:"[0-9a-zA-Z]{4,}$", options: .caseInsensitive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorAlarmText1.isHidden = true
        errorAlarmText2.isHidden = true
        
        backBtn.setImage(UIImage(named: "arrow_left"), for: .normal)
    }
    @IBAction func sendNewPassToServer() {
        checkPassVaild()
        if flag == 1 {
            let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
            guard let password = inputNewPass.text else {return}
            let param = ["phone":"\(phone)","pass":"\(password)"]
            networkModel.post(method: .put, param: param,url: networkURL.passwordUpdateURL) {
                json in
                if json["result"].boolValue {
                    print("비밀번호 변경 완료")
                    let vc = UIStoryboard.init(name: "ChangePass", bundle: nil).instantiateViewController(withIdentifier: "ChangePassComplete")
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    guard let pvc = self.presentingViewController else {return}
                    self.dismiss(animated: false) {
                        pvc.present(vc, animated: false, completion: nil)
                    }
                }
                else {
                    print("비밀번호 변경 실패")
                }
            }
        }
    }
    func checkPassVaild() {
        guard let newPass = inputNewPass.text else { return }
        guard let checkPass = checkNewPass.text else {return}
        let passVaild = regex?.matches(in: newPass, options: [], range: NSRange(location: 0, length: newPass.count))
        print("check vaild count : ",passVaild?.count)
        print("check check count : ", newPass.count)
        if (passVaild?.count == 1) {
            if (newPass != checkPass){
                self.errorAlarmText2.isHidden = false
                self.checkNewPass.addTarget(self, action: #selector(self.textFieldDidChange2(textField:)), for: .editingChanged)
            }
            else {
                flag = 1
            }
        }
        else {
            self.errorAlarmText1.isHidden = false
            self.inputNewPass.addTarget(self, action: #selector(self.textFieldDidChange1(textField:)), for: .editingChanged)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
        
    }
    @objc func textFieldDidChange1(textField: UITextField){
        errorAlarmText1.isHidden = true
    }
    @objc func textFieldDidChange2(textField: UITextField){
        errorAlarmText2.isHidden = true
    }
    @IBAction func backbutton() {
        self.dismiss(animated: true)
    }
}
