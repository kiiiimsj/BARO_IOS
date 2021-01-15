//
//  EssentialRadio.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/29.
//

import UIKit

class EssentialRadio : UICollectionViewCell {
    public var data = Extra()
    @IBOutlet weak var radioBtn: EssentialRadios!
    @IBOutlet weak var optionName: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class EssentialRadios : UIButton{
    override var isSelected: Bool{
        didSet{
            
        }
    }
}
