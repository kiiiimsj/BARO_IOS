//
//  BasketNonEssentialCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit

class BasketNonEssentialCell: UICollectionViewCell {
    
    @IBOutlet weak var extra_price: UILabel!
    @IBOutlet weak var extra_count: UILabel!
    @IBOutlet weak var extra_name: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        extra_price.text = ""
        extra_count.text = ""
        extra_name.text = ""
    }
}
