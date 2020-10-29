//
//  OrderHistoryDetailController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class OrderHistoryDetailController : UIViewController {
    
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requests: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    var orderHistoryDetailList = [OrderHistoryDetailList]()
    var extraList = [OrderHistoryDetailExtraList]()

    //전 페이지에서 받아올 정보들 4개
    var receipt_id = ""
    var store_name = ""
    var total_price = 0
    var order_count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        configure()
        
    }
    
    func configure() {
        
        
        networkModel.post(method: .get, url: networkURL.orderHistoryRegular + "?receipt_id=" + receipt_id) {
            json in
            var orderHistoryDetailModel = OrderHistoryDetailList()
            
            for item in json["orders"].array! {
                orderHistoryDetailModel.order_id = item["order_id"].intValue
                orderHistoryDetailModel.order_state = item["order_state"].stringValue
                orderHistoryDetailModel.order_count = item["order_count"].intValue
                orderHistoryDetailModel.menu_name = item["menu_name"].stringValue
                orderHistoryDetailModel.menu_defaultprice = item["menu_defaultprice"].intValue
                if let extra = item["extras"].array {
                    for item2 in extra {
                        var orderHistoryDetailExtraModel = OrderHistoryDetailExtraList()
                        orderHistoryDetailExtraModel.extra_count = item2["extra_count"].intValue
                        orderHistoryDetailExtraModel.extra_name = item2["extra_name"].stringValue
                        orderHistoryDetailExtraModel.extra_price = item2["extra_price"].intValue
                        orderHistoryDetailModel.OrderHistoryDetailExtra.append(orderHistoryDetailExtraModel)
                    }
                }
                self.orderHistoryDetailList.append(orderHistoryDetailModel)
            }
            self.tableView.reloadData()
            
        }
        
        
        storeName.text = store_name
        totalPrice.text = String(total_price)
        //요청사항도 찍어주기
    }
}

extension OrderHistoryDetailController : UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ppp",orderHistoryDetailList.count)
        return orderHistoryDetailList.count
    }
    
    //식별자 넣어주기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderList = orderHistoryDetailList[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryDetail", for: indexPath) as! OrderHistoryDetail
        
        //한 메뉴에 대한 total 가격 찍기
        var extra_total = 0
        for item in orderList.OrderHistoryDetailExtra {
            extra_total += (item.extra_price * item.extra_count)
        }
        var menu_one_total_price = (orderList.menu_defaultprice + extra_total)
        
        cell.menu_name.text = orderList.menu_name
        print("kkkkk", orderList.menu_name)
        cell.menu_default_price.text = String(orderList.menu_defaultprice)
        cell.menu_one_total_price.text = String(menu_one_total_price)
        cell.menu_count.text = String(orderList.order_count)
        cell.menu_total_price.text = String(menu_one_total_price * orderList.order_count)
        cell.extraList = orderList.OrderHistoryDetailExtra
        print("jkk", orderList.OrderHistoryDetailExtra)
        cell.collectionView.delegate = cell.self
        cell.collectionView.dataSource = cell.self
    
        return cell
    }
}
