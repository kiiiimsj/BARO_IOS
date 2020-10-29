//
//  OrderStatusDetail.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/29.
//

import UIKit

class OrderStatusDetail : UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuCount: UILabel!
    @IBOutlet weak var expandableImage: UIImageView!
    @IBOutlet weak var oneMenuTotalPrice: UILabel!
    @IBOutlet weak var menuName: UILabel!
    
  
    public var extraList = [OrderStatusDetailExtraList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
}

extension OrderStatusDetail : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("counttttt", extraList.count)
        return extraList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("pppppp")
        let extra = extraList[indexPath.item]
        print("hj", extra.extra_name)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusDetailCell", for: indexPath) as! OrderStatusDetailCell
        cell.extraName.text = extra.extra_name
        cell.extraPrice.text = String(extra.extra_price)
        print("pleee", extra.extra_name)
        print("pleee", extra.extra_price)
        
        return cell
    }
    
    
    
    
    
}
