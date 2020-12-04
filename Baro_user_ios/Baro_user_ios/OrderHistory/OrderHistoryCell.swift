//
//  OrderHistoryCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit
protocol historyDelegate  {
    func clickGoToStore(vc : AboutStore)
    func clickShowDetails(vc : OrderHistoryDetailController)
}
class OrderHistoryCell : UICollectionViewCell {
    public var cellDelegate : historyDelegate?
    public var cellData : OrderHistoryList?
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderStoreNameLabel: UILabel!
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
    var receipt_id = ""
  
    @IBOutlet weak var goToStoreBtn: UIButton!
    
    @IBOutlet weak var showDetailsBtn: UIButton!
    @IBOutlet weak var storeImage: UIImageView!
    @IBAction func pressGoToStore(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "AboutStore", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "AboutStore") as AboutStore
        vc.store_id = cellData!.store_id
        cellDelegate?.clickGoToStore(vc: vc)
    }
    @IBAction func pressShowDetails(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "OrderHistory", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "OrderHistoryDetailController") as! OrderHistoryDetailController
       
        vc.receipt_id = cellData!.receipt_id
        vc.order_count = cellData!.total_count
        vc.store_name = cellData!.store_name
        vc.total_price = cellData!.total_price
        cellDelegate?.clickShowDetails(vc: vc)
//        present(vc, animated: true, completion: nil)
    }
}
