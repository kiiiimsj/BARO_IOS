//
//  BottomTapBarControllerViewController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit
protocol isClick {
    func click()
}
class BottomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var indexValue: Int = 0
    var isClickDelegate : isClick!
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
    func setBottomViewInOtherController(view : UIView, targetController : UIViewController) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        targetController.addChild(controller)
        print("view size : ", view.frame.size.height)
        controller.view.frame = CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.width, height: 55)
        view.addSubview(controller.view)
        
    }
}
