//
//  CouponForBasket.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/08.
//

import UIKit
class CouponForBasket : UIViewController {
    let netWork = CallRequest()
    let urlMaker = NetWorkURL()
    let userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
    
    @IBOutlet weak var couponCollectionView: UICollectionView!
    public var totalPrice : Int = 0
    
    var coupons = [Coupon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("getTotalPrice", totalPrice)
        getCoupon()
        couponCollectionView.delegate = self
        couponCollectionView.dataSource = self
    }
    func getCoupon() {
        netWork.get(method: .get, url: urlMaker.couponListCanUse + "\(userPhone)" + "&price=\(self.totalPrice)") {
            json in
            if json["result"].boolValue {
                var coupon = Coupon()
                for item in json["coupon"].array! {
                    coupon.coupon_title = item["coupon_title"].stringValue
                    coupon.coupon_condition = item["coupon_condition"].intValue
                    coupon.coupon_id = item["coupon_id"].intValue
                    coupon.coupon_content = item["coupon_content"].stringValue
                    coupon.coupon_enddate = item["coupon_enddate"].stringValue
                    coupon.coupon_discount = item["coupon_discount"].intValue
                    coupon.coupon_type = item["coupon_type"].stringValue
                    self.coupons.append(coupon)
                }
            }
            else {
                
            }
        }
    }
}
extension CouponForBasket : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
struct Coupon {
    var coupon_title = ""
    var coupon_condition = 0
    var coupon_id = 0
    var coupon_content = ""
    var coupon_enddate = ""
    var coupon_discount = 0
    var coupon_type = ""
}
