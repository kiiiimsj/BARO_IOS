//
//  OrderHistoryDetail.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/26.
//

import UIKit

class OrderHistoryDetail : UICollectionViewCell {
    
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menu_default_price: UILabel!
    @IBOutlet weak var menu_one_total_price: UILabel!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var menu_total_price: UILabel!
    
    
    public var extraList = [OrderHistoryDetailExtraList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.collectionView.reloadData()
 
    }

}

extension OrderHistoryDetail : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Ffff",extraList.count)
        return extraList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let extra = extraList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderHistoryDetailCell", for: indexPath) as! OrderHistoryDetailCell
        cell.extraName.text =  "· " + extra.extra_name
        cell.extraCount.text = String(extra.extra_count)
        cell.extraPrice.text = "+ " + String(extra.extra_price * extra.extra_count) + "원"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    

}
