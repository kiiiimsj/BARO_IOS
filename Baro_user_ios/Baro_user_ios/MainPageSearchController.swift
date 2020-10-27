//
//  MainPageSearchController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class MainPageSearchController : UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    
    @IBAction func button(_ sender: Any) {
        if let text = searchBar.searchTextField.text {
            print(text)
            let realText = String(text)
            navigationController?.pushViewController(testController(), animated: false)
            performSegue(withIdentifier: "searchToStore", sender: realText)
        }
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextController = segue.destination as? testController else{
            return
        }
        
        if let labell = sender as? String {
            nextController.labelString = labell
        }
    }
}
