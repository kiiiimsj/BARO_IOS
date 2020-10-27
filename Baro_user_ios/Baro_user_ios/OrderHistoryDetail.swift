//
//  OrderHistoryDetail.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/26.
//

import UIKit

class OrderHistoryDetail : UITableViewCell {
    
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    var receipt_id = "5f43699f878a560047f9fea0"
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var menu_name: UILabel!
    
    @IBOutlet weak var menu_default_price: UILabel!
    
    @IBOutlet weak var menu_one_total_price: UILabel!
    
    @IBOutlet weak var menu_count: UILabel!
    
    @IBOutlet weak var menu_total_price: UILabel!
    
    
    var orderHistoryDetailList = [OrderHistoryDetailList]()
    var extraList = [OrderHistoryDetailExtraList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configure()
        
        //아메리카노 1500원 넣어주기
        //1500 x 1    1500원 넣어주기
        
    }
    
    func configure() {
        
        networkModel.post(method: .get, url: networkURL.orderHistoryDetail + "?receipt_id=" + receipt_id) {
            json in
            var orderHistoryDetailModel = OrderHistoryDetailList()
            var orderHistoryDetailExtraModel = OrderHistoryDetailExtraList()
            for item in json["orders"].array! {
                orderHistoryDetailModel.order_id = item["order_id"].intValue
                orderHistoryDetailModel.order_state = item["order_state"].stringValue
                orderHistoryDetailModel.order_count = item["order_count"].intValue
                orderHistoryDetailModel.menu_name = item["menu_name"].stringValue
                orderHistoryDetailModel.menu_defaultprice = item["menu_defaultprice"].intValue
//                for item2 in json["extras"].array! {
//                    orderHistoryDetailExtraModel.extra_count = item2["extra_count"].intValue
//                    orderHistoryDetailExtraModel.extra_name = item2["extra_name"].stringValue
//                    orderHistoryDetailExtraModel.extra_price = item2["extra_price"].intValue
//                    self.extraList.append(orderHistoryDetailExtraModel)
//                }
                self.orderHistoryDetailList.append(orderHistoryDetailModel)
            }
            self.collectionView.reloadData()
            
        }
        
    }
}

extension OrderHistoryDetail : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extraList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let extra = extraList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderHistoryDetailCell", for: indexPath) as! OrderHistoryDetailCell
        cell.extraName.text = extra.extra_name
        cell.extraPrice.text = String(extra.extra_price)
        return cell
    }
    
}
