//
//  MainPageController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit

class MainPageController: UIViewController {
    
    let typeList = TypeListModel()
    
    
    
    
    @IBOutlet weak var tableViewType: UITableView!
    
    @IBOutlet weak var tableViewEvent: UITableView!
    
    @IBOutlet weak var tableViewUltra: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewEvent.separatorStyle = .none
        tableViewType.separatorStyle = .none
        tableViewUltra.separatorStyle = .none
        
        
    }
    

    
}

extension MainPageController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableViewEvent){
            let cell = tableViewEvent.dequeueReusableCell(withIdentifier: "MainPageEvent", for: indexPath) as! MainPageEvent
            return cell
        }
        else if(tableView == tableViewType){
<<<<<<< HEAD
            let cell = tableViewType.dequeueReusableCell(withIdentifier: "MainPageType", for: indexPath) as! MainPageType
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        }
        else if(tableView == tableViewUltra){
            let cell = tableViewUltra.dequeueReusableCell(withIdentifier: "MainPageUltraStore", for: indexPath) as! MainPageUltraStore
            return cell
        }
        else {
            let cell = tableViewNewStore.dequeueReusableCell(withIdentifier: "MainPageNewStore", for: indexPath) as! MainPageNewStore
=======
            let cell = tableViewType.dequeueReusableCell(withIdentifier: "MainPageType", for: indexPath)
            return cell
        }
        else {
            let cell = tableViewUltra.dequeueReusableCell(withIdentifier: "MainPageUltraStore", for: indexPath)
>>>>>>> parent of 90138ff... Merge branch 'master' into hty
            return cell
        }
        
    }
<<<<<<< HEAD
   
=======
>>>>>>> parent of 90138ff... Merge branch 'master' into hty

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
<<<<<<< HEAD
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(tableView == tableViewType) {
            self.performSegue(withIdentifier: "MainPageType", sender: nil)
            print("oooo")
        }
    }
}
=======
>>>>>>> parent of 90138ff... Merge branch 'master' into hty

extension MainPageController : CellDelegate {
    func tapClick(tag: String) {
        print(tag)
    }
    
    
}
