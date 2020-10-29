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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        network.post(method: .get, url: networkURL.orderProgressList + "?phone=" + phone) {
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
        
        if orderStatus.order_state == "PREPARING" {
            cell.orderStatusProgress.setProgress(0.33, animated: false)
        }
        else if orderStatus.order_state == "ACCEPT" {
            cell.orderStatusProgress.setProgress(0.66, animated: false)
        }
        cell.orderCount.text = String(orderStatus.total_count) + "개"
        cell.orderTotalPriceLabel.text = String(orderStatus.total_price) + "원"
        cell.receipt_id = orderStatus.receipt_id
        return cell
    }
    
    //높이나 등등 처리하는 오버라이드 해주기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderStatus = orderStatusList[indexPath.item]
        
        let vc = self.storyboard?.instantiateViewController(identifier: "OrderStatusDetailController") as! OrderStatusDetailController
        
        vc.receipt_id = orderStatus.receipt_id
        vc.order_count = orderStatus.total_count
        vc.store_name = orderStatus.store_name
        vc.total_price = orderStatus.total_price
        
        present(vc, animated: true, completion: nil)
    }
    
}