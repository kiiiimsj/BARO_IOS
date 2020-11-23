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
        let toastLabel = UILabel(frame: CGRect(x: targetController.view.frame.size.width/2 - 100, y: targetController.view.frame.size.height-150, width: 200, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        targetController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
}
