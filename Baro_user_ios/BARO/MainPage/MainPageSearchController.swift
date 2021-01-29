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
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count <= 1 {
            return
        }
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.storeListControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.storeListStoryBoard
        let param = ["search":self.searchBar.text,"typeCode":"3"]
        ViewInBottomTabBar.controllerSender = param
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        guard let pvc = self.presentingViewController else {return}

        self.dismiss(animated: true) {
            pvc.present(ViewInBottomTabBar, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContent = searchText
        let dialogButtonForm = DialogForm()
        dialogButtonForm.setTopView(top: topViewLabel)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        if searchBar.text!.count <= 1 {
            return
        }
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.storeListControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.storeListStoryBoard
        let param = ["search":self.searchBar.text,"typeCode":"3"]
        ViewInBottomTabBar.controllerSender = param
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        guard let pvc = self.presentingViewController else {return}

        self.dismiss(animated: true) {
            pvc.present(ViewInBottomTabBar, animated: true, completion: nil)
        }
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

