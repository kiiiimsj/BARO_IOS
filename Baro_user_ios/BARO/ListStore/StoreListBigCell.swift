//
//  StoreListBigCell.swift
//  BARO
//
//  Created by . on 2021/03/24.
//

import UIKit

class  StoreListBigCell : UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var is_OpenLable: UILabel!
    @IBOutlet weak var distance_Label: UILabel!
    @IBOutlet weak var discount_rate_label: DiscountLabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
