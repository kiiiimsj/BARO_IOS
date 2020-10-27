//
//  MainPageUltraStoreCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

class MainPageUltraStoreCell : UICollectionViewCell {
    
    
    @IBOutlet weak var ultraImage: UIImageView!
    
    @IBOutlet weak var ultraName: UILabel!
    
    @IBOutlet weak var ultraInfo: UILabel!
    
    override func prepareForReuse() {
        ultraImage.image = nil
    }
}
