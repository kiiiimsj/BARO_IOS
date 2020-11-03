//
//  OrderStatusCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/28.
//

import UIKit

class OrderStatusCell : UICollectionViewCell {
    
    @IBOutlet weak var orderStoreNameLabel: UILabel!
    
    @IBOutlet weak var orderFirstMenuName: UILabel! //처리x

    @IBOutlet weak var orderStoreImage: UIImageView!
    
    @IBOutlet weak var orderStatusProgress: UIProgressView!
    
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
    @IBOutlet weak var orderCount: UILabel!
    
    
    var receipt_id = ""
    
    override func prepareForReuse() {
        orderStoreImage.image = nil
    }
}
