//
//  OptionCategoryHeader.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

class OptionCategoryHeader : UICollectionReusableView{
    
  
    
    @IBOutlet weak var optionCategory: UILabel!
    @IBOutlet weak var SelectedPrice: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        SelectedPrice = nil
        SelectedPrice.text = nil
    }
}
