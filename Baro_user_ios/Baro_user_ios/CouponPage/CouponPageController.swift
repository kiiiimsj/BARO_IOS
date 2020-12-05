//
//  CouponPageController.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/09.
//

import UIKit

class CouponPageController: UIViewController {
    var userPhone = ""
    var network = CallRequest()
    var urlMaker = NetWorkURL()
    var couponData = [CouponModel]()
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("couponPageViewDidLoad")
        userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
        print("userPhone : ", userPhone)
        collection.delegate = self
        collection.dataSource = self
        network.get(method: .get, url: urlMaker.couponList+userPhone) { (json) in
            print(json)
            if json["result"].boolValue {
                for item in json["coupon"].array! {
                    var temp = CouponModel()
                    temp.coupon_title = item["coupon_title"].stringValue
                    temp.coupon_condition = item["coupon_condition"].intValue
                    temp.coupon_id = item["coupon_id"].intValue
                    temp.coupon_content = item["coupon_content"].stringValue
                    temp.coupon_enddate = item["coupon_enddate"].stringValue
                    temp.coupon_discount = item["coupon_discount"].doubleValue
                    temp.coupon_type = item["coupon_type"].stringValue
                    self.couponData.append(temp)
                }
                self.collection.reloadData()
            }
        }
    }
}

extension CouponPageController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return couponData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath) as! CouponCell
        let data = couponData[indexPath.item]
        cell.coupon = data
        cell.couponTitle.text = data.coupon_title
        cell.CouponContent.text = data.coupon_content
        cell.CouponEndDate.text = data.coupon_enddate+"까지"
        cell.couponCondition.text = String(data.coupon_condition)+"원 이상 구매시 적용 가능"
        cell.backgroundColor = .purple
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
     
}
