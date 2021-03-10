//
//  BasketHeader.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit

class BasketHeader : UICollectionReusableView {
    @IBOutlet weak var storeName : UILabel!
    @IBOutlet weak var store_discount_label: DiscountLabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
