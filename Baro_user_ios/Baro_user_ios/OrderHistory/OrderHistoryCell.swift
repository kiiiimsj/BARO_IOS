//
//  OrderHistoryCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import UIKit

class OrderHistoryCell : UICollectionViewCell {
    
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderStoreNameLabel: UILabel!
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
    var receipt_id = ""
  
}
