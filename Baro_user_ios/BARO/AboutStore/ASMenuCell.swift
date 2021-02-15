//
//  ASMenuCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/20.
//

import UIKit

class ASMenuCell : UICollectionViewCell {
    
    @IBOutlet weak var menu_picture: UIImageView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_description: UILabel!
    @IBOutlet weak var menu_price: UILabel!
    @IBOutlet weak var menu_state: UILabel!
    @IBOutlet weak var realPrice: CustomLabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
