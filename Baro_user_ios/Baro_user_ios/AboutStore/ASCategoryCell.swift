//
//  ASCategoryCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/20.
//

import UIKit
class ASCategoryCell : UICollectionViewCell{
    
    @IBOutlet var category: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // 초기화 할 코드 예시
        category.titleLabel?.text = nil
    }
}
