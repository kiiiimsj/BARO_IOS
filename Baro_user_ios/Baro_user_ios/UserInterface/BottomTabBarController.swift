//
//  BottomTapBarControllerViewController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit

class BottomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var indexValue: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedIndex = indexValue
    }
    @IBInspectable var selected_index: Int {
       get {
           return selectedIndex
       }
       set(index) {
           selectedIndex = index
       }
    }
    
}
