//
//  PhoneSendForRegister.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/26.
//

import UIKit
import FirebaseAuth
class PhoneSendForRegister : UIViewController, DialogClickDelegate{
    func clickDialog(verificationID: String) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PhoneCheckForRegister") as! PhoneCheckForRegister
        vc.verificationID = verificationID
        if let num = inputPhone.text {
            vc.phoneNumber = num
        }else{
            return
        }
        vc.marketing = self.marketing
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        guard let pvc = self.presentingViewController else {return}
        self.dismiss(animated: false) {
            pvc.present(vc, animated: true)
        }
    }
    
    
    let nationNumber = "+82"
    @IBOutlet weak var inputPhone: UITextField!
    @IBOutlet weak var sendPhoneToFireBaseBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    public var netWork = CallRequest()
    public var urlMaker = NetWorkURL()
    public var marketing = false
    let bottomTabBarInfo = BottomTabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        sendPhoneToFireBaseBtn.layer.cornerRadius = 15
        backBtn.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor.white
        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
        
        inputPhone.borderStyle = .none
        swipeRecognizer()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
    @IBAction func backBtnPressed() {
        self.dismiss(animated: true)
    }
    @IBAction func sendPhone() {
        if let authNumber = inputPhone.text {
            let range = authNumber.index(authNumber.startIndex, offsetBy: 0)..<authNumber.endIndex
            let nationPhoneNumber = nationNumber + authNumber[range]
            netWork.get(method: .get, url: urlMaker.phoneNumberCheckURL+authNumber ){ json in
                if json["result"].boolValue {
                    PhoneAuthProvider.provider().verifyPhoneNumber(nationPhoneNumber, uiDelegate: nil) {(verificationID, error) in
                        if let error = error {
                            print(error)
                            let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                            dialog.message = "요청오류 : 잠시후 다시 시도해주세요"
                            dialog.modalPresentationStyle = .overFullScreen
                            dialog.modalTransitionStyle = .crossDissolve
                            self.present(dialog, animated: true)
                          return
                        }
                        let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                        dialog.message = "해당 핸드폰에 인증문자를 발송했습니다."
                        dialog.dialogClickDelegate = self
                        dialog.verificationID = verificationID!
                        dialog.modalPresentationStyle = .overFullScreen
                        dialog.modalTransitionStyle = .crossDissolve
                        self.present(dialog, animated: true)
                        if(dialog.isBeingDismissed) {
                        
                        }
                        //pvc.performSegue(withIdentifier: "PhoneCheckForRegister", sender: verificationID)
                    }
                } else {
                    let dialog = self.storyboard?.instantiateViewController(identifier: "DuplicateNumber") as! DuplicateNumber
                    dialog.modalPresentationStyle = .overFullScreen
                    dialog.modalTransitionStyle = .crossDissolve
                    self.present(dialog, animated: true)
                }
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhoneCheckForRegister
        vc.verificationID = sender as! String
        if let num = inputPhone.text {
            vc.phoneNumber = num
        }
    }
}
