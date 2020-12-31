//
//  LoginDialog.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/12/30.
//

import UIKit
protocol DialogClickDelegate {
    func clickDialog(verificationID : String)
}
class LoginDialog : UIViewController {
    @IBOutlet weak var okayBtn: UIButton!
    @IBOutlet weak var dialogContent: UILabel!
    var dialogClickDelegate : DialogClickDelegate?
    var message : String = ""
    var verificationID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogContent.text = message
    }
    @IBAction func clickBtn() {
        self.dismiss(animated: true)
        if(verificationID != "") {
            dialogClickDelegate?.clickDialog(verificationID: verificationID)
        }
    }
}
