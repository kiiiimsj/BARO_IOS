//
//  OrderStatusDetailController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/29.
//

import UIKit

class OrderStatusDetailController : UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPrice: UILabel!

    @IBOutlet weak var mRequests: UILabel!
    
    
    @IBAction func successBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
  //  public var extraOpen = false
    
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
     
        collectionView.delegate = self
        collectionView.dataSource = self
        configure()
        
    }
    
    
    func configure() {
        networkModel.post(method: .get, url: networkURL.orderHistoryRegular + "?receipt_id=" + receipt_id) {
            json in
            print("rr", json)
            let requests = json["requests"].stringValue
            //print("req", requests)
            if requests == "" {
                self.mRequests.text = "요청사항 없음"
            }
            else {
                self.mRequests.text = requests
            }
            for item in json["orders"].array! {
                var orderStatusDetailModel = OrderStatusDetailList()
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
            
            self.collectionView.reloadData()
            print("ggg", self.orderStatusDetailList)
        }
        storeName.text = String(store_name)
        totalPrice.text = String(total_price) + "원"
        //요청사항도 찍어주기
    }
}

extension OrderStatusDetailController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderStatusDetailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let orderList = orderStatusDetailList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusDetail", for: indexPath) as! OrderStatusDetail
        //셀에 값 넣어주기
        //self.mRequests.text = orderList.requests
        cell.menuName.text = orderList.menu_name
        cell.menuCount.text = String(orderList.order_count) + "개"
        for item in orderList.OrderStatusDetailExtra {
            print("ll",item.extra_name)
        }

        var extra_total = 0
        for item in orderList.OrderStatusDetailExtra {
            extra_total += (item.extra_price * item.extra_count)
        }
        let menu_one_total_price = (orderList.menu_defaultprice + extra_total)
        cell.oneMenuTotalPrice.text = "합계 : " + String(orderList.order_count * menu_one_total_price) + "원"

        cell.extraList = orderList.OrderStatusDetailExtra
        cell.optionContainEachPrice.text =  String(menu_one_total_price) + "원"
        cell.eachPrice.text = String(orderList.menu_defaultprice) + "원"
        cell.collectionView.delegate = cell.self
        cell.collectionView.dataSource = cell.self
     //   cell.clickListener = self

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orderList = orderStatusDetailList[indexPath.item]
        
        
    //    if self.extraOpen {
        return CGSize(width: collectionView.frame.width, height: CGFloat(orderList.OrderStatusDetailExtra.count) * 20 + 70)
   //     }
//        else {
//            return CGSize(width: self.view.frame.width * 0.8, height: 0)
//        }
    }
    
}

//extension OrderStatusDetailController : ExpandableDelegate {
//    func clickExpand(open: Bool, iPath: IndexPath) {
//        print("uuz",open)
//        self.extraOpen = open
//        print(extraOpen)
//        let layout = collectionView.collectionViewLayout
//        layout.invalidateLayout()
//    }
//}
