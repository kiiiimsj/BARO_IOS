//
//  ChangePass.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/26.
//

import UIKit
class ChangePass : UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
    }
    @IBAction func backbutton(_ sender : Any) {
        self.performSegue(withIdentifier: "MyPageController", sender: nil)
    }
}
