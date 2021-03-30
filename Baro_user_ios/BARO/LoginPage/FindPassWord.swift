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
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendPhoneToFireBaseBtn.layer.cornerRadius = 15
        backBtn.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor.white
        Auth.auth().settings!.isAppVerificationDisabledForTesting = false
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
    @IBAction func clickBackBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func clickSendNumber(_ sender: Any) {
        if let authNumber = inputPhone.text {
            let range = authNumber.index(authNumber.startIndex, offsetBy: 0)..<authNumber.endIndex
            let nationPhoneNumber = nationNumber + authNumber[range]
            PhoneAuthProvider.provider().verifyPhoneNumber(nationPhoneNumber, uiDelegate: nil) {(verificationID, error) in
                if let error = error {
                    print(error)
                    let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                    dialog.message = "\(error.localizedDescription)"
                    dialog.modalPresentationStyle = .overFullScreen
                    dialog.modalTransitionStyle = .crossDissolve
                    self.present(dialog, animated: true)
                  return
                }
                let dialog = self.storyboard?.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
                dialog.message = "해당 핸드폰에 인증문자를 발송했습니다."
                dialog.modalPresentationStyle = .overFullScreen
                dialog.modalTransitionStyle = .crossDissolve
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
