//
//  StoreListCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/23.
//

import UIKit

class  StoreListCell : UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var is_OpenLable: UILabel!
    @IBOutlet weak var distance_Label: UILabel!
    @IBOutlet weak var discount_rate_label: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
