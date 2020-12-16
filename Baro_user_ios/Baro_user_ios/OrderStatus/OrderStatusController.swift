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
    
    var phone = UserDefaults.standard.value(forKey: "user_phone") as! String
    var storePhone : String = ""
    
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
                orderStatusModel.store_phone = item["store_phone"].stringValue
                orderStatusModel.total_price = item["total_price"].intValue
                orderStatusModel.order_state = item["order_state"].stringValue
                orderStatusModel.total_count = item["total_count"].intValue
                orderStatusModel.store_image = item["store_image"].stringValue
                
                self.orderStatusList.append(orderStatusModel)
            }
            self.collectionView.reloadData() //해줘야함
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
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
        storePhone = orderStatus.store_phone
        cell.orderTotalPriceLabel.text = String(orderStatus.total_price)
        cell.orderStoreImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + orderStatus.store_image))
        cell.orderInfo = orderStatus
        cell.timeLabel.text = orderStatus.order_date
        cell.makeStatus(state: orderStatus.order_state)
        cell.delegate = self
//        cell.showDetailBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetail(_:))))
//        cell.callStoreBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callStore(_:))))
//        cell.setupViews()
        return cell
    }
    
    //높이나 등등 처리하는 오버라이드 해주기
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.frame.height)
//    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let orderStatus = orderStatusList[indexPath.item]
//        let vc = self.storyboard?.instantiateViewController(identifier: "OrderStatusDetailController") as! OrderStatusDetailController
//        
//        vc.receipt_id = orderStatus.receipt_id
//        vc.order_count = orderStatus.total_count
//        vc.store_name = orderStatus.store_name
//        vc.total_price = orderStatus.total_price
//        
//        present(vc, animated: true, completion: nil)
    }
    
//    @objc func callStore(_ sender: UITapGestureRecognizer) {
//
//    }
//    @objc func showDetail(_ sender: UITapGestureRecognizer) {
//
//    }
}

extension OrderStatusController : statusDelegate {
    func callStore(vc: UIViewController) {
//        let urlString = "tel://" + storePhone
//        let numberURL = NSURL(string: urlString)
//        UIApplication.shared.canOpenURL(numberURL! as URL)
        guard let url = URL(string: "telprompt://\(storePhone)") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func showDetails(vc: OrderStatusDetailController) {
        present(vc, animated: true, completion: nil)
    }
    
    
}
