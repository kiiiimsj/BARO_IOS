//
//  BottomTapBarControllerViewController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit
protocol isClick : AnyObject{
    func clickEventDelegate(item : UITabBarItem)
}
class BottomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var indexValue: Int = 0
    weak var eventDelegate : isClick?
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
    func setBottomViewInOtherController(view : UIView, targetController : UIViewController, controller : UITabBarController) {
        targetController.addChild(controller)
        controller.view.frame = CGRect(x: 0, y: view.frame.size.height - 65, width: view.frame.width, height: 50)
        view.addSubview(controller.view)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        eventDelegate?.clickEventDelegate(item: item)
        print("tag print : ", item.tag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selected_index = (sender as? Int)!
    }
}
