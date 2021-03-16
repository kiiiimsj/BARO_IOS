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
        left.layer.borderWidth = 1
        left.layer.borderColor = UIColor.baro_main_color.cgColor
        left.layer.masksToBounds = true
    }
    func setTopView(top: UIView) {
        top.layer.cornerRadius = 5
        top.layer.borderColor = UIColor.baro_main_color.cgColor
        top.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        top.layer.masksToBounds = true
    }
}
