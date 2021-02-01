//
//  FirstPageController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2021/01/05.
//

import UIKit

class FirstPageController : UIViewController {
    @IBOutlet weak var orderText: UILabel!
    @IBOutlet weak var catchText: UILabel!
    @IBOutlet weak var baroText: UILabel!
    
    let bottomTabBarInfo = BottomTabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        orderText.isHidden = true
        catchText.isHidden = true
        baroText.isHidden = true
        
        orderText.transform = CGAffineTransform(translationX: (-view.frame.width/2) + orderText.bounds.maxX, y: 0)
        orderText.alpha = 0.2
        
        catchText.transform = (catchText?.transform.rotated(by: -CGFloat.pi/6))!
        catchText.alpha = 0.2
        
        baroText.transform = CGAffineTransform(translationX: 0, y: self.baroText.bounds.minY + 50)
        baroText.alpha = 0.2
        UIView.animate(withDuration: 0.7) {
            self.orderText.isHidden = false
            self.orderText.alpha = 1
            self.orderText.transform = CGAffineTransform(translationX: self.orderText.bounds.minX, y: 0.0)
        } completion: { _ in
            UIView.animate(withDuration: 0.7) {
                self.catchText.isHidden = false
                self.catchText.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.7) {
                    self.baroText.isHidden = false
                    self.baroText.alpha = 1
                    self.baroText.transform = CGAffineTransform(translationX: 0, y: self.baroText.bounds.minY - 30)
                    self.catchText.transform = CGAffineTransform(translationX: 0, y: 0)
                } completion: { _ in
                    self.toMainPageUseBottomBar()
                }
            }
        }
    }
    func toMainPageUseBottomBar() {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        
        
//        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.mainPageControllerIdentifier
//        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.mainPageStoryBoard
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.newMainPageControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.newMainPageStoryBoard
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.dismiss(animated: false) {
            self.present(ViewInBottomTabBar, animated: true, completion: nil)
        }
    }
}
