//
//  StoreNotOpen.swift
//  Baro_user_ios
//
//  Created by . on 2021/01/08.
//

import UIKit

class StoreNotOpen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func clickOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "basket")
//        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
//        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
//        let bottomTabBarInfo = BottomTabBarController()
//        //        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.mainPageControllerIdentifier
//        //        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.mainPageStoryBoard
//                ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.newMainPageControllerIdentifier
//                ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.newMainPageStoryBoard
//        ViewInBottomTabBar.moveFromOutSide = true
//        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
//        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
//        self.present(ViewInBottomTabBar, animated: true, completion: nil)
        if AboutStore.this?.presentingViewController == nil {
            BasketController.this?.presentingViewController?.dismiss(animated: false, completion: nil)
        }else{
            AboutStore.this?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
