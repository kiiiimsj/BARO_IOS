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
        yesBtn.layer.cornerRadius = 5
        yesBtn.layer.masksToBounds = true
        yesBtn.layer.borderWidth = 1
        yesBtn.layer.borderColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1).cgColor
        noBtn.layer.cornerRadius = 5
        noBtn.layer.masksToBounds = true
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
