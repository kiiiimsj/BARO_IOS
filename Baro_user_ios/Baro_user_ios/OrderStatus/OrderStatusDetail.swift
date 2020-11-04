//
//  OrderStatusDetail.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/29.
//

import UIKit

class OrderStatusDetail : UICollectionViewCell {
    
 //   @IBOutlet weak var expandBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var oneMenuTotalPrice: UILabel!
    
//    var clickListener : ExpandableDelegate?
//    var iPath = IndexPath()
//    var expandable = false
//    var open = false

    @IBOutlet weak var menuCount: UILabel!
    
    
//    @IBAction func expandableImage(_ sender: Any) {
//        open = !open
//        if open {
//            let image = UIImage(named: "heart")
//            print("heart")
//            expandBtn.setImage(image, for: .normal)
//        }
//        else {
//            let image = UIImage(named: "arrow_down")
//            print("arrow")
//            expandBtn.setImage(image, for: .normal)
//        }
//        print("hae", iPath)
//        clickListener?.clickExpand(open: open, iPath: iPath)
//    }
    
    public var extraList = [OrderStatusDetailExtraList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
    
}

//protocol ExpandableDelegate {
//    func clickExpand(open : Bool, iPath : IndexPath)
//}

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
        return CGSize(width: 50, height: 30)
    }
    
}
