//
//  BasketEssentialCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit

class BasketEssentialCell : UICollectionViewCell{
    
    @IBOutlet weak var extraNames: UILabel!
    @IBOutlet weak var extraPrice: UILabel!
    override func prepareForReuse() {
            super.prepareForReuse()
            extraNames.text = ""
            extraPrice.text = ""
        }
}
