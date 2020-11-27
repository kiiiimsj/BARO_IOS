//
//  PhoneSendForRegister.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/26.
//

import UIKit
import FirebaseAuth
class PhoneSendForRegister : UIViewController {
    let nationNumber = "+1"
    @IBOutlet weak var inputPhone: UITextField!
    @IBOutlet weak var sendPhoneToFireBaseBtn: UIButton!
    var ToasstMessage = ToastMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendPhoneToFireBaseBtn.layer.cornerRadius = 15
        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
            
    }
    
    @IBAction func sendPhone() {
        if let authNumber = inputPhone.text {
            let range = authNumber.index(authNumber.startIndex, offsetBy: 0)..<authNumber.endIndex
            let nationPhoneNumber = nationNumber + authNumber[range]
            print("phone : ",nationPhoneNumber)
            PhoneAuthProvider.provider().verifyPhoneNumber(nationPhoneNumber, uiDelegate: nil) {(verificationID, error) in
                if let error = error {
                    self.ToasstMessage.showToast(message: error.localizedDescription, font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                  return
                }
                self.ToasstMessage.showToast(message: "해당 핸드폰에 인증문자를 발송했습니다.", font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
                self.performSegue(withIdentifier: "PhoneCheckForRegister", sender: verificationID)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhoneCheckForRegister
        vc.firebaseAuthString = sender as! String
    }
}
