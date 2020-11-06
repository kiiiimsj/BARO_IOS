//
//  MainPageEventCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

class MainPageEventCell : UICollectionViewCell {
    
    
    @IBOutlet weak var eventImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImage.image = nil
    }
}
