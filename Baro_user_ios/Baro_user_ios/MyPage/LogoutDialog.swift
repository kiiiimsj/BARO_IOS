//
//  LogoutDialog.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/30.
//

import UIKit
protocol ClickLogoutDialogDelegate {
    func clickYesBtnDelegate()
}
class LogoutDialog : UIViewController {
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    var delegate : ClickLogoutDialogDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        yesBtn.layer.borderWidth = 1
        yesBtn.layer.cornerRadius = 5
        noBtn.layer.borderWidth = 1
        noBtn.layer.cornerRadius = 5

        yesBtn.layer.borderColor = UIColor(red: 131/255.0, green: 51/255.0, blue: 230/255.0, alpha: 1).cgColor
        noBtn.layer.borderColor = UIColor(red: 131/255.0, green: 51/255.0, blue: 230/255.0, alpha: 1).cgColor
    }
    @IBAction func clickNoBtn() {
        self.dismiss(animated: true)
    }
    @IBAction func clickYesBtn() {
        self.dismiss(animated: true) {
            self.delegate?.clickYesBtnDelegate()
        }
    }
}
