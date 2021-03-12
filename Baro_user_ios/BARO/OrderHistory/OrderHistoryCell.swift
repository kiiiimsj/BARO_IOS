//
//  OrderHistoryCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit
protocol historyDelegate  {
    func clickGoToStore(vc : UIViewController)
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

    var store_id = 0
    
    let bottomTabBarInfo = BottomTabBarController()
    @IBOutlet weak var goToStoreBtn: UIButton!
    
    @IBOutlet weak var showDetailsBtn: UIButton!
    @IBOutlet weak var storeImage: UIImageView!
    @IBAction func pressGoToStore(_ sender: Any) {
        let network = CallRequest()
        let urlMaker = NetWorkURL()
        print(cellData)
        network.get(method: .get, url: urlMaker.reloadStoreDiscount+String(cellData!.store_id)) { [self] json in
            
            if json["result"].boolValue {
                let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
                let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
                ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.aboutStoreControllerIdentifier
                ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.aboutStoreStoryBoard
                let data = ["id" : cellData!.store_id,"discount_rate" : json["discount_rate"].intValue] as [String : Any]
                ViewInBottomTabBar.controllerSender = data
                ViewInBottomTabBar.moveFromOutSide = true
                ViewInBottomTabBar.tempStoreName = cellData!.store_name
                ViewInBottomTabBar.modalPresentationStyle = .fullScreen
                ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
                
                cellDelegate?.clickGoToStore(vc: ViewInBottomTabBar)
            }
            
        }
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
