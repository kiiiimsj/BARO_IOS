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
    
}
