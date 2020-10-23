//
//  MyPageController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/22.
//

import UIKit

class MyPageController : UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserName()
    }
    
    func setUserName() {
        let user_name = "\(UserDefaults.standard.value(forKey: "user_name") as! String)"
        if user_name != "" {
            userName.text = "\(user_name)"
        }
        let user_email = "\(UserDefaults.standard.value(forKey: "user_email") as! String)"
        if user_email != "" {
            userEmail.text = "\(user_email)"
        }
    }
}
