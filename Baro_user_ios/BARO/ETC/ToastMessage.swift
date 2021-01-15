//
//  ToastMessage.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/18.
//

import UIKit
protocol Toast {
    func makeToast()
}
class ToastMessage : UIViewController {
    var delegate : Toast!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showToast(message : String, font: UIFont, targetController : UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: targetController.view.frame.size.width/2 - ((CGFloat(message.count) * 10.0) / 2), y: targetController.view.frame.size.height-150, width: (CGFloat(message.count) * 10.0), height: (CGFloat(message.count)/20) * 5))
        var strMessage = message
        if(strMessage.count > 20) {
            var count = 0
            for _ in strMessage {
                count+=1
                if(count % 20 == 0) {
                    let index = strMessage.index(strMessage.startIndex, offsetBy: count)
                    strMessage.insert("\n", at: index)
                }
            }
        }
        toastLabel.numberOfLines = Int(((CGFloat(message.count) * 10.0) / 10))
        toastLabel.backgroundColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = strMessage
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        targetController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
}
