//
//  OrderStatusDetail.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/29.
//

import UIKit

class OrderStatusDetail : UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var oneMenuTotalPrice: UILabel!
    @IBOutlet weak var expandableImage: UIButton!
    @IBOutlet weak var menuCount: UILabel!
    
    
    public var extraList = [OrderStatusDetailExtraList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
    
}

extension OrderStatusDetail : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("uu", extraList.count)
        return extraList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let extra = extraList[indexPath.item]
        print("hj", extra.extra_name)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusDetailCell", for: indexPath) as! OrderStatusDetailCell
        cell.extraName.text = extra.extra_name
        cell.extraPrice.text = "+" + String(extra.extra_price) + "원"

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 70)
    }
    
}
