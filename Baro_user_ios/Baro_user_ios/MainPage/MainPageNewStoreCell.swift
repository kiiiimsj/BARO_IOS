//
//  MainPageNewStoreCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/21.
//

import UIKit

class MainPageNewStoreCell : UICollectionViewCell {
    
    @IBOutlet weak var newStoreImage: UIImageView!
    
    @IBOutlet weak var newStoreName: UILabel!
    
    @IBOutlet weak var newStoreInfo: UILabel!
    
    override func prepareForReuse() {
        newStoreImage.image = nil
    }
}
