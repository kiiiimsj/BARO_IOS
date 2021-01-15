//
//  NothingExist.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/14.
//

import UIKit

class NothingExist: UIViewController {
    @IBOutlet weak var okayBtn: UIButton!
    @IBAction func clickOkay(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        okayBtn.layer.cornerRadius = 5
        okayBtn.layer.borderColor = UIColor.white.cgColor
        okayBtn.layer.borderWidth = 2
        okayBtn.layer.masksToBounds = true
    }
    
}
