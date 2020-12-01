//
//  FinalPaymentCheckDialog.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/09.
//

import UIKit
protocol PaymentDialogDelegate {
    func clickPaymentCheckBtn()
}
class FinalPaymentCheckDialog : UIViewController {
    @IBOutlet weak var dialogTitle: UILabel!
    @IBOutlet weak var dialogContent: UILabel!
    @IBOutlet weak var dialogButtonTitle: UIButton!
    var titleContentString = ""
    var dialogContentString = ""
    var buttonTitleContentString = ""
    var delegate : PaymentDialogDelegate?
    
    @IBAction func clickPaymentCheckButton() {
        self.dismiss(animated: false) {
            self.delegate?.clickPaymentCheckBtn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogTitle.layer.cornerRadius = 5
        dialogTitle.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        dialogTitle.layer.borderWidth = 1
        dialogTitle.layer.borderColor = CGColor(srgbRed: 151/255, green: 51/255, blue: 230/255, alpha: 1)
        dialogTitle.text = titleContentString
        dialogContent.text = dialogContentString
        dialogButtonTitle.setTitle(buttonTitleContentString, for: .normal)
    }
}
