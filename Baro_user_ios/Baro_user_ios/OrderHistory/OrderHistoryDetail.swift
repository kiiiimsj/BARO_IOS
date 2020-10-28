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
    
    var order_id = 0
    //값 넘겨주기
    
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_default_price: UILabel!
    @IBOutlet weak var menu_one_total_price: UILabel!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var menu_total_price: UILabel!
    
    
    var orderHistoryDetailList = [OrderHistoryDetailExtraList]()
    var extraList = [OrderHistoryDetailExtraList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configure()
        
        print("ttt",order_id)
        
        //아메리카노 1500원 넣어주기
        //1500 x 1    1500원 넣어주기
        
    }
    
    func configure() {
        networkModel.post(method: .get, url: networkURL.orderHistoryDetailExtra + "?order_id=" + String(order_id)) {
                json in
                var orderHistoryDetailExtraModel = OrderHistoryDetailExtraList()
                for item in json["extras"].array! {
                    orderHistoryDetailExtraModel.extra_name = item["extra_name"].stringValue
                    orderHistoryDetailExtraModel.extra_price = item["extra_price"].intValue
                    orderHistoryDetailExtraModel.extra_count = item["extra_count"].intValue
                }
                self.orderHistoryDetailList.append(orderHistoryDetailExtraModel)
            }
            self.collectionView.reloadData()
            
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
