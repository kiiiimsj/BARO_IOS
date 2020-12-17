//
//  FindPassWord.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/16.
//

import UIKit
import FirebaseAuth

class FindPassWord: UIViewController {
    let nationNumber = "+82"
    @IBOutlet weak var sendPhoneToFireBaseBtn: UIButton!
    @IBOutlet weak var inputPhone: UITextField!
    var ToasstMessage = ToastMessage()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("fpw")
        sendPhoneToFireBaseBtn.layer.cornerRadius = 15
        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
        inputPhone.borderStyle = .none
        swipeRecognizer()
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
                self.dismiss(animated: false, completion: nil)
            default: break
            }
        }
    }
    @IBAction func clickSendNumber(_ sender: Any) {
        print("clcik")
        if let authNumber = inputPhone.text {
            let range = authNumber.index(authNumber.startIndex, offsetBy: 0)..<authNumber.endIndex
            let nationPhoneNumber = nationNumber + authNumber[range]
            print("phone : ",nationPhoneNumber)
            PhoneAuthProvider.provider().verifyPhoneNumber(nationPhoneNumber, uiDelegate: nil) {(verificationID, error) in
                if let error = error {
                    print(error)
                    self.ToasstMessage.showToast(message: error.localizedDescription, font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                  return
                }
                self.ToasstMessage.showToast(message: "해당 핸드폰에 인증문자를 발송했습니다.", font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "PhoneCheckForChangePW") as! PhoneCheckForChangePW
                if let num = self.inputPhone.text {
                    vc.phoneNumber = num
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.verificationID = verificationID!
                    guard let pvc = self.presentingViewController else { return }
                    self.dismiss(animated: false){
                        pvc.present(vc, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
}