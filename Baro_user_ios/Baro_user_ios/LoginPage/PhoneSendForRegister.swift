//
//  PhoneSendForRegister.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/26.
//

import UIKit
import FirebaseAuth
class PhoneSendForRegister : UIViewController {
    let nationNumber = "+82"
    @IBOutlet weak var inputPhone: UITextField!
    @IBOutlet weak var sendPhoneToFireBaseBtn: UIButton!
    let bottomTabBarInfo = BottomTabBarController()
    var ToasstMessage = ToastMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendPhoneToFireBaseBtn.layer.cornerRadius = 15
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
            print("gesture")
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
            print("phone : ",nationPhoneNumber)
            PhoneAuthProvider.provider().verifyPhoneNumber(nationPhoneNumber, uiDelegate: nil) {(verificationID, error) in
                if let error = error {
                    print(error)
                    self.ToasstMessage.showToast(message: error.localizedDescription, font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                  return
                }
                self.ToasstMessage.showToast(message: "해당 핸드폰에 인증문자를 발송했습니다.", font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                let vc = self.storyboard?.instantiateViewController(identifier: "PhoneCheckForRegister") as! PhoneCheckForRegister
                vc.verificationID = verificationID!
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
                
                //self.performSegue(withIdentifier: "PhoneCheckForRegister", sender: verificationID)
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
