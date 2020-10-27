//
//  testController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/22.
//

import UIKit

class testController : UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var labelString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hhh",labelString)
        label.text = labelString
    }
}
