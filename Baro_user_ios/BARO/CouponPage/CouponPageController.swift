//
//  CouponPageController.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/09.
//

import UIKit

class CouponPageController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var typeCouponNumber: UITextField!
    var userPhone = ""
    var network = CallRequest()
    var urlMaker = NetWorkURL()
    var couponData = [CouponModel]()
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
        configureUI()
        collection.delegate = self
        collection.dataSource = self
        typeCouponNumber.delegate = self
        reloadCoupon()
    }
    func configureUI(){
        registerBtn.layer.borderColor = UIColor.customLightGray.cgColor
        registerBtn.layer.borderWidth = 2
        registerBtn.layer.cornerRadius = 5
    }
    @IBAction func pressRegister(_ sender: Any) {
        guard typeCouponNumber != nil else { return }
        network.get(method: .get, url: urlMaker.couponRegister+"phone="+userPhone+"&coupon_id="+typeCouponNumber.text!) { (json) in
            let storyboard = UIStoryboard(name: "Coupon", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "CouponRegisterController") as! CouponRegisterController
            vc.messageText = json["message"].stringValue
            if json["result"].boolValue {
                vc.titleText = "쿠폰 등록 성공"
            } else{
                vc.titleText = "쿠폰 등록 실패"
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: {
                self.reloadCoupon()
            })
//            if json["result"].boolValue {
//
//            }
        }
    }
    func reloadCoupon(){
        couponData = [CouponModel]()
        network.get(method: .get, url: urlMaker.couponList+userPhone) { (json) in
            if(json["coupon"].array != nil) {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.init(red: 131/255, green: 51/255, blue: 230/255, alpha: 0.5).cgColor
        cell.layer.cornerRadius = 10
//        cell.backgroundColor = .purple
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
     
}
