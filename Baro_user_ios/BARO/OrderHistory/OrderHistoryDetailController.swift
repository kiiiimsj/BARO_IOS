//
//  OrderHistoryDetailController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class OrderHistoryDetailController : UIViewController {
    
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var couponDiscountPriceLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var requests: CustomLabel!
    
    @IBOutlet weak var okayBtn: UIButton!
    
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    var orderHistoryDetailList = [OrderHistoryDetailList]()
    var extraList = [OrderHistoryDetailExtraList]()
    var requestText = ""
    //전 페이지에서 받아올 정보들 4개
    var receipt_id = ""
    var store_name = ""
    var total_price = 0
    var order_count = 0
    var coupon_discount = 0
    var discount_rate = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        configure()
        
    }
    
    @IBAction func pressBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func configure() {
        networkModel.post(method: .get, url: networkURL.orderHistoryRegular + "?receipt_id=" + receipt_id) {
            json in
            print(json)
            if json["result"].boolValue {
                self.requestText = json["requests"].stringValue
                self.coupon_discount = json["coupon_discount"].intValue
                self.discount_rate = json["discount_rate"].intValue
                for item in json["orders"].array! {
                    var orderHistoryDetailModel = OrderHistoryDetailList()
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
                if self.requestText == "null" || self.requestText == "" {
                    self.requests.text = "요청없음"
                }else{
                    self.requests.text = self.requestText
                }
                self.couponDiscountPriceLabel.text = "쿠폰 할인 금액 : \(self.coupon_discount) 원"
                self.totalPrice.text = "총 결제 금액 : " + String(self.total_price.applyDiscountRate(discount_rate: self.discount_rate) - self.coupon_discount) + "원"
                self.collectionView.reloadData()
            }
            
        }
        okayBtn.layer.borderWidth = 2
        okayBtn.layer.borderColor = UIColor.white.cgColor
        okayBtn.layer.cornerRadius = 5
        storeName.text = store_name
        
        //요청사항도 찍어주기
    }
}

extension OrderHistoryDetailController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderHistoryDetailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let orderList = orderHistoryDetailList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderHistoryDetail", for: indexPath) as! OrderHistoryDetail

        //한 메뉴에 대한 total 가격 찍기
        var extra_total = 0
        for item in orderList.OrderHistoryDetailExtra {
            extra_total += (item.extra_price * item.extra_count)
        }
        let menu_one_total_price = (orderList.menu_defaultprice + extra_total)

        cell.menu_name.text = String(orderList.menu_name)
        cell.menu_default_price.text = String(orderList.menu_defaultprice) + "원"
        cell.menu_one_total_price.text = String(menu_one_total_price) + "원"
        cell.menu_count.text = String(orderList.order_count)
        cell.menu_total_price.text = String(menu_one_total_price * orderList.order_count)
        cell.menu_total_price.attributedText = cell.menu_total_price.text?.strikeThrough()
        cell.realPrice.text = String((menu_one_total_price * orderList.order_count).applyDiscountRate(discount_rate: discount_rate))  + "원"
        cell.extraList = orderList.OrderHistoryDetailExtra
        
        cell.collectionView.delegate = cell.self
        cell.collectionView.dataSource = cell.self
        cell.collectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orderList = orderHistoryDetailList[indexPath.item]
        return CGSize(width: collectionView.frame.width, height: CGFloat(orderList.OrderHistoryDetailExtra.count) * 20 + 70)
    }
    
}
