//
//  MainPageTypeCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

class MainPageTypeCell : UICollectionViewCell {
    
    
    @IBOutlet weak var typeImage: UIImageView!
    
    @IBOutlet weak var typeName: UILabel!
    
    override func prepareForReuse() {
        typeImage.image = nil
    }
}
