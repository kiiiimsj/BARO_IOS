//
//  DialogForm.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/12/01.
//

import UIKit
class DialogForm : UIButton {
    func setRightbutton(right: UIButton) {
        right.layer.cornerRadius = 5
        right.layer.masksToBounds = true
    }
    func setLeftButton(left: UIButton) {
        left.layer.cornerRadius = 5
        left.layer.masksToBounds = true
        left.layer.borderWidth = 1
        left.layer.borderColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1).cgColor
    }
    func setTopView(top: UIView) {
        top.layer.cornerRadius = 5
        top.layer.masksToBounds = true
        top.layer.borderColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1).cgColor
        top.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
