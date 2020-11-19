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
    
    var phone = "01093756927"
    var startPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("iii")
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HistoryLoadingCell")
        configureView()
//        initRefresh()
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            var orderHistoryModel = OrderHistoryList()
            for item in json["order"].array! {
                print(json)
                orderHistoryModel.order_date = item["order_date"].stringValue
                orderHistoryModel.receipt_id = item["receipt_id"].stringValue
                orderHistoryModel.store_name = item["store_name"].stringValue
                orderHistoryModel.total_price = item["total_price"].intValue
                orderHistoryModel.order_state = item["order_state"].stringValue
                orderHistoryModel.total_count = item["total_count"].intValue
                self.orderHistoryList.append(orderHistoryModel)
            }
            self.collectionView.reloadData()
        }
    }
    
    func configureView(){
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func initRefresh(){
        let refresh = UIRefreshControl()
        startPoint += 20
        refresh.addTarget(self, action: #selector(loadData(_:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        if #available(iOS 10.0, *){
            collectionView.refreshControl = refresh
        }
        else{
            collectionView.addSubview(refresh)
        }
    }
    @objc func loadData(_ refreshControll : UIRefreshControl) {
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            var orderHistoryModel = OrderHistoryList()
            for item in json["order"].array! {
                print(json)
                orderHistoryModel.order_date = item["order_date"].stringValue
                orderHistoryModel.receipt_id = item["receipt_id"].stringValue
                orderHistoryModel.store_name = item["store_name"].stringValue
                orderHistoryModel.total_price = item["total_price"].intValue
                orderHistoryModel.order_state = item["order_state"].stringValue
                orderHistoryModel.total_count = item["total_count"].intValue
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
        }else if section == 1 && callMoreData {
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
            cell.orderDateLabel.text = String(orderHistory.order_date)
            cell.orderStoreNameLabel.text = String(orderHistory.store_name)
            cell.orderStatusLabel.text = String(orderHistory.order_state)
            cell.orderTotalPriceLabel.text = String(orderHistory.total_price)
            cell.receipt_id = orderHistory.receipt_id
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
            return CGSize(width: collectionView.frame.width, height: 100)
        }else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderHistory = orderHistoryList[indexPath.item]
        
        let vc = self.storyboard?.instantiateViewController(identifier: "OrderHistoryDetailController") as! OrderHistoryDetailController
       
        vc.receipt_id = orderHistory.receipt_id
        vc.order_count = orderHistory.total_count
        vc.store_name = orderHistory.store_name
        vc.total_price = orderHistory.total_price
        
        present(vc, animated: true, completion: nil)
         
    }
}

extension OrderHistoryController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height-100 - collectionView.frame.size.height){
            print("바닥에 닿음")
            if !callMoreData {
                loadData()
                print("ddddd",startPoint)
            }
            
        }
    }
    func loadData(){
        callMoreData = true
        network.post(method: .get, url: networkURL.orderHistoryList + "?phone=" + phone + "&startPoint=" + String(startPoint)) {
            json in
            print("받는중")
            var orderHistoryModel = OrderHistoryList()
            if json["result"].boolValue {
                self.collectionView.reloadSections(IndexSet(integer: 1))
                for item in json["order"].array! {
    //                    self.collectionView. createSpinnerFooter()
                    print(json)
                    orderHistoryModel.order_date = item["order_date"].stringValue
                    orderHistoryModel.receipt_id = item["receipt_id"].stringValue
                    orderHistoryModel.store_name = item["store_name"].stringValue
                    orderHistoryModel.total_price = item["total_price"].intValue
                    orderHistoryModel.order_state = item["order_state"].stringValue
                    orderHistoryModel.total_count = item["total_count"].intValue
                    self.orderHistoryList.append(orderHistoryModel)
                }
                self.collectionView.reloadData()
                self.startPoint += 20
            }
            self.callMoreData = false
        }
    }
}


