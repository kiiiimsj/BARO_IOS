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
        dialogTitle.text = titleContentString
        dialogContent.text = dialogContentString
        dialogButtonTitle.setTitle(buttonTitleContentString, for: .normal)
    }
}
