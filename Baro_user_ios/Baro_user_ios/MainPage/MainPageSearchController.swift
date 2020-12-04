//
//  MainPageSearchController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class MainPageSearchController : UIViewController, UISearchBarDelegate {
    
    var searchContent = ""
    let bottomTabBarInfo = BottomTabBarController()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContent = searchText
        print("searchh", searchContent)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.storeListControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.storeListStoryBoard
        ViewInBottomTabBar.controllerSender = "3"
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
        //navigationController?.pushViewController(StoreListPageController(), animated: false)
//        self.dismiss(animated: false)
//
//        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "StoreListPageController") as! StoreListPageController
//
//        guard let pvc = self.presentingViewController else { return }
//        self.dismiss(animated: false) {
//            vc.modalPresentationStyle = .fullScreen
//            vc.kind = 3
//            vc.searchWord = self.searchContent
//            pvc.present(vc, animated: false, completion: nil)
//        }
        
    }
    
    
    @IBOutlet weak var search: UIButton!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func cancelBtn() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
//        self.search.layer.borderWidth = 2
//        self.search.layer.borderColor = UIColor.purple.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? StoreListPageController else {
            return
        }
        let labell = sender as! String
        nextViewController.searchWord = labell
        nextViewController.kind = 3
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.pushViewController(StoreListPageController(), animated: false)
        
//        performSegue(withIdentifier: "searchToStoreList", sender: searchContent)
        
        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "StoreListPageController") as! StoreListPageController
        
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: false) {
            vc.modalPresentationStyle = .overFullScreen
            vc.kind = 3
            vc.searchWord = self.searchContent
            pvc.present(vc, animated: false, completion: nil)
            
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

