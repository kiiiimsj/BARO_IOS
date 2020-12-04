//
//  MainPageSearchController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class MainPageSearchController : UIViewController, UISearchBarDelegate {
    @IBOutlet weak var topViewLabel: UILabel!
    
    var searchContent = ""
    let bottomTabBarInfo = BottomTabBarController()
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func cancelBtn() {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
//        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
//        
//        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.storeListControllerIdentifier
//        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.storeListStoryBoard
//        ViewInBottomTabBar.controllerSender = self.searchContent
//        ViewInBottomTabBar.moveFromOutSide = true
//        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
//        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
//        self.present(ViewInBottomTabBar, animated: true, completion: nil)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContent = searchText
        print("searchh", searchContent)
        let dialogButtonForm = DialogForm()
        dialogButtonForm.setTopView(top: topViewLabel)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.storeListControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.storeListStoryBoard
        ViewInBottomTabBar.controllerSender = self.searchContent
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if searchBar.text!.count >= 10 {
            return false
        }
        else{
            return true
        }
    }
}

