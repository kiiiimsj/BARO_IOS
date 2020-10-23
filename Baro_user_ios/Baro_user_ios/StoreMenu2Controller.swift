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
        cell.menu_name.text  = menus[indexPath.item].menu_name
        return cell
    }
    
    
}
