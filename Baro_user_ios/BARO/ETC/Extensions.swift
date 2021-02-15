//
//  Extensions.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/04.
//

import UIKit

class Extensions {
    
}
extension UIColor {
    static var baro_main_color = UIColor.init(red: 131/255, green: 51/255, blue: 230/255, alpha: 1)
    static var customLightGray = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
}
extension String {
    // 취소선 긋기
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.red, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

