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

extension Int {
    func applyDiscountRate (discount_rate : Int) -> Int {
        return self * (100 - discount_rate) / 100 
    }
    
}
class DiscountLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 4.0
        @IBInspectable var bottomInset: CGFloat = 4.0
        @IBInspectable var leftInset: CGFloat = 5.0
        @IBInspectable var rightInset: CGFloat = 5.0
    override init(frame : CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textColor = UIColor.baro_main_color
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.baro_main_color.cgColor
        self.backgroundColor = UIColor.white
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textColor = UIColor.baro_main_color
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.baro_main_color.cgColor
        self.backgroundColor = UIColor.white
    }
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                         height: size.height + topInset + bottomInset)
    }
    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}


