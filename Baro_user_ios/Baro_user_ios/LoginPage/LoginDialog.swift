//
//  LoginDialog.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/12/30.
//

import UIKit
class LoginDialog : UIViewController {
    @IBOutlet weak var okayBtn: UIButton!
    @IBOutlet weak var dialogContent: UILabel!
    var message : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogContent.text = message
    }
    @IBAction func clickBtn() {
        self.dismiss(animated: true)
    }
}
