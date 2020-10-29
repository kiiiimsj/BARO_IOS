//
//  OrderStatusDetailController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/29.
//

import UIKit

class OrderStatusDetailController : UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var requests: UILabel!
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    var orderStatusDetailList = [OrderStatusDetailList]()
    var extraList = [OrderStatusDetailExtraList]()
    
    //전 페이지에서 받아올 정보 4개
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
            var orderStatusDetailModel = OrderStatusDetailList()
            
            for item in json["orders"].array! {
                orderStatusDetailModel.order_id = item["order_id"].intValue
                orderStatusDetailModel.order_state = item["order_state"].stringValue
                orderStatusDetailModel.order_count = item["order_count"].intValue
                orderStatusDetailModel.menu_name = item["menu_name"].stringValue
                orderStatusDetailModel.menu_defaultprice = item["menu_defaultprice"].intValue
                if let extra = item["extras"].array {
                    for item2 in extra {
                        var orderStatusDetailExtraModel = OrderStatusDetailExtraList()
                        orderStatusDetailExtraModel.extra_count = item2["extra_count"].intValue
                        orderStatusDetailExtraModel.extra_name = item2["extra_name"].stringValue
                        orderStatusDetailExtraModel.extra_price = item2["extra_price"].intValue
                        orderStatusDetailModel.OrderStatusDetailExtra.append(orderStatusDetailExtraModel)
                    }
                }
                self.orderStatusDetailList.append(orderStatusDetailModel)
            }
            self.tableView.reloadData()
        }
        storeName.text = store_name
        totalPrice.text = String(total_price)
        //요청사항도 찍어주기
    }
}

extension OrderStatusDetailController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("yui", orderStatusDetailList.count)
        return orderStatusDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderList = orderStatusDetailList[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusDetail", for: indexPath) as! OrderStatusDetail
        //셀에 값 넣어주기
        cell.menuName.text = orderList.menu_name
        cell.menuCount.text = String(orderList.order_count)
        for item in orderList.OrderStatusDetailExtra {
            print("ll",item.extra_name)
        }
        //cell의 이미지는 아직 처리 안함
       
        var extra_total = 0
        for item in orderList.OrderStatusDetailExtra {
            extra_total += (item.extra_price * item.extra_count)
        }
        var menu_one_total_price = (orderList.menu_defaultprice + extra_total)
        cell.oneMenuTotalPrice.text = String(menu_one_total_price)
        
        cell.extraList = orderList.OrderStatusDetailExtra
        print("jkk", orderList.OrderStatusDetailExtra)
        cell.collectionView.delegate = cell.self
        cell.collectionView.dataSource = cell.self
        
        return cell
    }
    
    
}
