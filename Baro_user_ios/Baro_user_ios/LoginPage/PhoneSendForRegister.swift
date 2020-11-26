//
//  PhoneSendForRegister.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/26.
//

import UIKit
class PhoneSendForRegister : UIViewController {
    @IBOutlet weak var inputPhone: UITextField!
    @IBOutlet weak var sendPhoneToFireBaseBtn: UIButton!
    var authNumber : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        sendPhoneToFireBaseBtn.layer.cornerRadius = 15
        
    }
    
    @IBAction func sendPhone() {
        self.performSegue(withIdentifier: "PhoneCheckForRegister", sender: "")
    }
}
