//
//  MainPageSearchController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class MainPageSearchController : UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
//    @IBAction func button(_ sender: Any) {
//        if let text = searchBar.searchTextField.text {
//            print("kkkk",text)
//            let realText = String(text)
//            navigationController?.pushViewController(StoreListPageController(), animated: false)
//            performSegue(withIdentifier: "searchToStoreList", sender: realText)
//        }
//    }
    
    @IBAction func searchBtn(_ sender: Any) {
        if let text = searchBar.searchTextField.text {
            print("kkkkk", text)
        }
    }
    
    
    
    @IBAction func cancelBtn() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.backgroundColor = .purple
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? StoreListPageController else{
            return
        }
        if let labell = sender as? String {
            nextViewController.typeCode = labell
        }
    }
}
