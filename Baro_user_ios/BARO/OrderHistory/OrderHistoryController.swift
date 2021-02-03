//
//  OrderHistoryController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class OrderHistoryController : UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var callMoreData = false
    var orderHistoryList = [OrderHistoryList]()
    let network = CallRequest()
    let networkURL = NetWorkURL()
    
    var phone = UserDefaults.standard.value(forKey: "user_phone") as! String
    var startPoint = 0
    var end = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HistoryLoadingCell")
        configureView()
//        initRefresh()
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            var orderHistoryModel = OrderHistoryList()
            for item in json["order"].array! {
                orderHistoryModel.store_id = item["store_id"].intValue
                orderHistoryModel.store_phone = item["store_phone"].stringValue
                orderHistoryModel.store_latitude = item["store_latitude"].doubleValue
                orderHistoryModel.store_longitude = item["store_longitude"].doubleValue
                orderHistoryModel.order_date = item["order_date"].stringValue
                orderHistoryModel.receipt_id = item["receipt_id"].stringValue
                orderHistoryModel.store_name = item["store_name"].stringValue
                orderHistoryModel.total_price = item["total_price"].intValue
                orderHistoryModel.order_state = item["order_state"].stringValue
                orderHistoryModel.total_count = item["total_count"].intValue
                orderHistoryModel.store_image = item["store_image"].stringValue
                orderHistoryModel.store_id = item["store_id"].intValue
            
                self.orderHistoryList.append(orderHistoryModel)
            }
            if json["order"].array!.count < 20 {
                self.collectionView.reloadData()
                self.end = true
            }
            self.collectionView.reloadData()
        }
    }
    
    func configureView(){
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc func loadData(_ refreshControll : UIRefreshControl) {
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            var orderHistoryModel = OrderHistoryList()
            for item in json["order"].array! {
                orderHistoryModel.store_id = item["store_id"].intValue
                orderHistoryModel.store_phone = item["store_phone"].stringValue
                orderHistoryModel.store_latitude = item["store_latitude"].doubleValue
                orderHistoryModel.store_longitude = item["store_longitude"].doubleValue
                orderHistoryModel.order_date = item["order_date"].stringValue
                orderHistoryModel.receipt_id = item["receipt_id"].stringValue
                orderHistoryModel.store_name = item["store_name"].stringValue
                orderHistoryModel.total_price = item["total_price"].intValue
                orderHistoryModel.order_state = item["order_state"].stringValue
                orderHistoryModel.total_count = item["total_count"].intValue
                orderHistoryModel.store_image = item["store_image"].stringValue
                self.orderHistoryList.append(orderHistoryModel)
            }
            refreshControll.endRefreshing()
            self.collectionView.reloadData()
            
        }
    }
}

extension OrderHistoryController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return orderHistoryList.count
        }else if section == 1 && callMoreData && !end {
            return 1
        }else{
            return 0
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let orderHistory = orderHistoryList[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderHistoryCell", for: indexPath) as! OrderHistoryCell
            cell.storeImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + String(orderHistory.store_image)))
            cell.orderDateLabel.text = String(orderHistory.order_date)
            cell.orderStoreNameLabel.text = String(orderHistory.store_name)
            if orderHistory.order_state == "CANCEL" {
                cell.orderStatusLabel.text = "주문취소"
            }
            else if orderHistory.order_state == "DONE" {
                cell.orderStatusLabel.text = "수령완료"
            }
            else {
                cell.orderStatusLabel.text = "????"
            }
            cell.cellData = orderHistory
            cell.orderTotalPriceLabel.text = "합계 : " + String(orderHistory.total_price) + " 원"
            cell.cellDelegate = self
            cell.goToStoreBtn.layer.borderColor = UIColor.init(red: 131/255, green: 51/255, blue: 230/255, alpha: 1) .cgColor
            cell.goToStoreBtn.layer.borderWidth = 1
            cell.goToStoreBtn.layer.cornerRadius = 10
            cell.goToStoreBtn.layer.masksToBounds = true
            cell.showDetailsBtn.layer.borderColor = UIColor.init(red: 131/255, green: 51/255, blue: 230/255, alpha: 1) .cgColor
            cell.showDetailsBtn.layer.borderWidth = 1
            cell.showDetailsBtn.layer.cornerRadius = 10
            cell.showDetailsBtn.layer.masksToBounds = true
            
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCellCollectionViewCell
            cell.loading.startAnimating()
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: collectionView.frame.width, height: 180)
        }else {
            return CGSize(width: collectionView.frame.width, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let orderHistory = orderHistoryList[indexPath.item]
//        
//        let vc = self.storyboard?.instantiateViewController(identifier: "OrderHistoryDetailController") as! OrderHistoryDetailController
//       
//        vc.receipt_id = orderHistory.receipt_id
//        vc.order_count = orderHistory.total_count
//        vc.store_name = orderHistory.store_name
//        vc.total_price = orderHistory.total_price
//        
//        present(vc, animated: true, completion: nil)
         
    }
}

extension OrderHistoryController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height-100 - collectionView.frame.size.height){
            if !end {
                if !callMoreData {
                    loadData()
                }
            }
            
        }
    }
    func loadData(){
        callMoreData = true
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            var orderHistoryModel = OrderHistoryList()
            if json["result"].boolValue {
                self.collectionView.reloadSections(IndexSet(integer: 1))
                for item in json["order"].array! {
    //                    self.collectionView. createSpinnerFooter()
                    orderHistoryModel.order_date = item["order_date"].stringValue
                    orderHistoryModel.receipt_id = item["receipt_id"].stringValue
                    orderHistoryModel.store_name = item["store_name"].stringValue
                    orderHistoryModel.total_price = item["total_price"].intValue
                    orderHistoryModel.order_state = item["order_state"].stringValue
                    orderHistoryModel.total_count = item["total_count"].intValue
                    self.orderHistoryList.append(orderHistoryModel)
                }
                if json["order"].array!.count < 20 {
                    self.collectionView.reloadData()
                    self.end = true
                }else{
                    self.collectionView.reloadData()
                    self.startPoint += 20
                    self.callMoreData = false
                }
            }
            
        }
    }
}

extension OrderHistoryController : historyDelegate {
    func clickGoToStore(vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func clickGoToStore(vc: AboutStore) {
//        present(vc, animated: true, completion: nil)
    }
    
    func clickShowDetails(vc: OrderHistoryDetailController) {
        present(vc, animated: false, completion: nil)
    }
}

