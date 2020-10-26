//
//  ChangeEmail.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/26.
//

import UIKit
class ChangeEmail : UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
    }
    @IBAction func backbutton() {
        self.performSegue(withIdentifier: "MyPageController", sender: nil)
    }
}
