//
//  CouponForBasketCell.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/08.
//

import UIKit
protocol ClickCouponBtn : AnyObject {
    func btnClickCoupon(cell : CouponForBasketCell)
}
class CouponForBasketCell : UICollectionViewCell {
    @IBOutlet weak var couponTitle: UILabel!
    @IBOutlet weak var couponCanUseDate: UILabel!
    @IBOutlet weak var couponPrice: UILabel!
    @IBOutlet weak var cilckCoupon: UIButton!
    weak var couponDelegate : ClickCouponBtn?
    
    @IBAction func clickCell(_ sender : AnyObject) {
        couponDelegate?.btnClickCoupon(cell: self)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
