//
//  MainPageController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit

class MainPageController: UIViewController {
    
    
    
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
            let cell = tableViewEvent.dequeueReusableCell(withIdentifier: "MainPageEvent", for: indexPath)
            return cell
        }
        else {
            let cell = tableViewType.dequeueReusableCell(withIdentifier: "MainPageType", for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}
