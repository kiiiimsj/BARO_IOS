//
//  StoreMenu2Controller.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/20.
//

import UIKit

private let cellIdentifier = "ASMenuCell"
class StoreMenu2Controller : UIViewController{
    public var menus = [Menu]()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension StoreMenu2Controller : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ASMenuCell
        let data : Menu = menus[indexPath.item]
        cell.menu_name.text  = data.menu_name
        cell.menu_description.text  = data.menu_info
        cell.menu_price.text  = String(data.menu_defaultprice)+"원"
        cell.menu_state.text = "품절"
        if data.is_soldout == "N"{
            cell.menu_state.isHidden = true
            
        }
        
        return cell
    }
    
    
}
