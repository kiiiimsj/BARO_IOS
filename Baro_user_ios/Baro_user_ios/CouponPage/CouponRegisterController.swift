//
//  CouponRegisterController.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/07.
//

import UIKit

class CouponRegisterController: UIViewController {
    var titleText : String?
    var messageText : String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var okayBtn: UIButton!
    @IBAction func pressOkay(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        message.text = messageText
    }
}
