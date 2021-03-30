//
//  CouponForBasket.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/08.
//

import UIKit
class CouponForBasket : UIViewController {
    static var this : CouponForBasket?
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
    public var discount_rate : Int = 0
    public var restoreFrameValue : CGFloat = 0.0
    let userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var pay: UIButton!
    
    
    public var totalPrice : Int = 0
    
    var coupons = [Coupon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidload")
        CouponForBasket.this = self
        customerRequest.delegate = self
        restoreFrameValue = self.view.frame.origin.y
        getCoupon()
        setFirstLabelText()
        DialogTitle.layer.cornerRadius = 5
        DialogTitle.layer.borderColor = UIColor.baro_main_color.cgColor
        DialogTitle.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        let pvc = parent as? BasketController
        pvc?.couponDiallog = nil
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
        vc.discount_rate = self.discount_rate
        
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
        pay.setTitle("\(realPriceValue)원 결제하기", for: .normal)
    }
    func discountChnage(newValue : Int,newDiscount_rate : Int){
        print("SAdfasd")
        totalPrice = newValue
        productTotalPrice.text = "\(totalPrice)원"
        realPriceValue = totalPrice-couponDiscountValue
        realPayPrice.text = "\(realPriceValue)원"
        discount_rate = newDiscount_rate
        pay.setTitle("\(realPriceValue)원 결제하기", for: .normal)
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
        print("dsfa")
        if currentSelectedCoupon == cell {
            self.UseCouponId = -1
            self.realPriceValue = self.totalPrice
            self.couponDiscountValue = 0
            self.realPayPrice.text =  "\(realPriceValue)원"
            self.currentSelectedCoupon = nil
            self.couponDiscountPrice.text = "\(couponDiscountValue)원"
            cell.contentView.backgroundColor = .white
            pay.setTitle("\(realPriceValue)원 결제하기", for: .normal)
            return
        }else{
            currentSelectedCoupon?.contentView.backgroundColor = .white
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
        pay.setTitle("\(realPriceValue)원 결제하기", for: .normal)
        
        self.currentSelectedCoupon = cell
        
        cell.contentView.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 255/255, alpha: 1)
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
        return CGSize(width: couponCollectionView.frame.width-20, height: 100)
    }
    
}
extension CouponForBasket : UITextFieldDelegate {
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if self.view.frame.origin.y == restoreFrameValue{
            self.view.frame.origin.y -= keyboardHeight
            }
        }
    }

    @objc func keyboardWillDisappear(noti: NSNotification) {
        if self.view.frame.origin.y != restoreFrameValue {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
            }
        }
    }

//self.view.frame.origin.y = restoreFrameValue

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = restoreFrameValue
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = self.restoreFrameValue
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
            
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        if text.count > 25 {
            textField.deleteBackward()
            return false
        }
            
        return true
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
