//
//  uiViewSettingAttribute.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/20.
//

import UIKit
class uiViewSetting: UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                if self.restorationIdentifier == "MyPageSquare" {
                    return
                }
                if self.restorationIdentifier == "categoryIndecator" {
                    return
                }
                if self.restorationIdentifier == "FavoriteDialog" {
                    return
                }
                if self.restorationIdentifier == "CouponBasketDialog" {
                    return
                }
                if self.restorationIdentifier == "checkFinalPaymentDialog" {
                    return
                }
                if self.restorationIdentifier == "BootPayDialog" {
                    return
                }
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }

        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        
        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.borderColor = color.cgColor
                } else {
                    layer.borderColor = nil
                }
            }
        }
        
        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }
        
        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }
        
        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
        
        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    
}
