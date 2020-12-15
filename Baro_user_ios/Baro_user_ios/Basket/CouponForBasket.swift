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
    @IBOutlet weak var productTotalPrice: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var couponDiscountPrice: UILabel!
    @IBOutlet weak var realPayPrice: UILabel!
    @IBOutlet weak var customerRequest: UITextField!
    @IBOutlet weak var couponExistLabel: UILabel!
    @IBOutlet weak var DialogTitle: UIView!
    var currentSelectedCoupon : CouponForBasketCell?
    public var sendOrderToBootPay = [Order]()
    public var UseCouponId : Int = -1
    public var couponDiscountValue : Int = 0
    public var realPriceValue : Int = 0
    let userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
   
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var pay: UIButton!
    
    
    public var totalPrice : Int = 0
    
    var coupons = [Coupon]()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCoupon()
        setFirstLabelText()
        DialogTitle.layer.cornerRadius = 5
        DialogTitle.layer.borderColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1).cgColor
        DialogTitle.layer.masksToBounds = true
    }
    
    @IBAction func clickPayButton() {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BootPayPage") as! MyBootPayController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.customerRequest = self.customerRequest.text!
        vc.myOrders = self.sendOrderToBootPay
        vc.couponId = self.UseCouponId
        vc.totalPrice = self.totalPrice
        vc.couponDiscountValue = self.couponDiscountValue
        vc.realPrice = self.realPriceValue
        
        guard let pvc = self.presentingViewController else {return}
        
        self.dismiss(animated: true) {
            pvc.present(vc, animated: true, completion: nil)
        }
    }
    func setFirstLabelText() {
        realPriceValue = totalPrice
        productTotalPrice.text = "\(totalPrice)원"
        couponDiscountPrice.text = "0원"
        realPayPrice.text = "\(realPriceValue)원"
        
    }
    func getCoupon() {
        print("getUserPhone : ", userPhone, "getTotalPrice", totalPrice)
        netWork.get(method: .get, url: urlMaker.couponListCanUse + "\(userPhone)" + "&price=\(self.totalPrice)") {
            json in
            if json["result"].boolValue {
                var coupon = Coupon()
                print(json)
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
                if self.coupons.count == 0 {
                    self.couponExistLabel.isHidden = false
                }else{
                    self.couponExistLabel.isHidden = true
                }
                self.couponCollectionView.delegate = self
                self.couponCollectionView.dataSource = self
            }
            else {
                self.couponExistLabel.isHidden = false
            }
        }
    }
    @IBAction func pressBackBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension CouponForBasket : UICollectionViewDelegate, ClickCouponBtn, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func btnClickCoupon(cell: CouponForBasketCell) {
        if currentSelectedCoupon == cell {
            self.UseCouponId = -1
            self.realPriceValue = self.totalPrice
            self.couponDiscountValue = 0
            self.realPayPrice.text =  "\(realPriceValue)원"
            self.currentSelectedCoupon = nil
            self.couponDiscountPrice.text = "\(couponDiscountValue)원"
            cell.backgroundColor = .white
            return
        }else{
            currentSelectedCoupon?.backgroundColor = .white
        }
        let indexPath = self.couponCollectionView.indexPath(for: cell)
        let couponData = self.coupons[indexPath!.item]
        var changedTotalValue : Int = 0
        
        if (couponData.coupon_type == "DISCOUNT") {
            changedTotalValue = (self.totalPrice - couponData.coupon_discount)
            self.couponDiscountPrice.text = "\(couponData.coupon_discount)원"
        }
        else {
            let ifSale = (self.totalPrice * couponData.coupon_discount / 100 )
            changedTotalValue = (self.totalPrice - ifSale)
            self.couponDiscountPrice.text = "\(ifSale)원"
        }
        
        self.realPriceValue = changedTotalValue
        self.couponDiscountValue = couponData.coupon_discount
        self.realPayPrice.text = "\(changedTotalValue)원"
        self.UseCouponId = couponData.coupon_id
        
        
        self.currentSelectedCoupon = cell
        
        cell.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 255/255, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indexCouponData = self.coupons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponForBasketCell", for: indexPath) as! CouponForBasketCell
        cell.couponTitle.text = indexCouponData.coupon_title
        if indexCouponData.coupon_type == "DISCOUNT" {
            cell.couponPrice.text = "\(indexCouponData.coupon_discount) 원"
        }else if indexCouponData.coupon_type == "SALE" {
            cell.couponPrice.text = "\(indexCouponData.coupon_discount) %"
        }else{
            
        }
        
        cell.couponCanUseDate.text = indexCouponData.coupon_enddate
        cell.couponDelegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: couponCollectionView.frame.width, height: 100)
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
