//
//  CouponCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/10.
//

import UIKit

class CouponCell: UICollectionViewCell {
    
    var coupon : CouponModel?
    @IBOutlet weak var couponTitle: UILabel!
    @IBOutlet weak var couponCondition: UILabel!
    @IBOutlet weak var CouponContent: UILabel!
    @IBOutlet weak var CouponEndDate: UILabel!
}
