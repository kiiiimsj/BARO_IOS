//
//  OrderStatusController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/28.
//

import UIKit

class OrderStatusController : UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var orderStatusList = [OrderStatusList]()
    let network = CallRequest()
    let networkURL = NetWorkURL()
    
    var phone = "01093756927"
    var startPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            var orderStatusModel = OrderStatusList()
            for item in json["order"].array! {
                print(json)
                orderStatusModel.order_date = item["order_date"].stringValue
                orderStatusModel.receipt_id = item["receipt_id"].stringValue
                orderStatusModel.store_name = item["store_name"].stringValue
                orderStatusModel.total_price = item["total_price"].intValue
                orderStatusModel.order_state = item["order_state"].stringValue
                orderStatusModel.total_count = item["total_count"].intValue
                self.orderStatusList.append(orderStatusModel)
            }
            self.collectionView.reloadData()
        }
    }
    
    func configureView() {
        view.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
}

extension OrderStatusController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderStatusList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let orderStatus = orderStatusList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusCell", for: indexPath) as! OrderStatusCell
        cell.orderStoreNameLabel.text = String(orderStatus.store_name)
        
        
        
        
        return cell
    }
    
}
