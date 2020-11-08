//
//  MainPageSearchController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class MainPageSearchController : UIViewController, UISearchBarDelegate {
    
    var searchContent = ""
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContent = searchText
        print("searchh", searchContent)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        navigationController?.pushViewController(StoreListPageController(), animated: false)
        performSegue(withIdentifier: "searchToStoreList", sender: searchContent)
        
    }
    
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func cancelBtn() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? StoreListPageController else {
            return
        }
        let labell = sender as! String
        nextViewController.searchWord = labell
        nextViewController.kind = 3
    }
}
