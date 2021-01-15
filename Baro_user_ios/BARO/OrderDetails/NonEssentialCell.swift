//
//  nonEssentialCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import Foundation

import UIKit

class NonEssentialCell : UICollectionViewCell{
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var optionCount: UILabel!
    @IBOutlet weak var optionName: UILabel!
    var clickListner : CellDelegateNonExtra?
    var nonEssentialExtras = Extra()
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @IBAction func AddCount(_ sender: Any) {
        var number : Int = Int(optionCount.text!)!
        guard number >= nonEssentialExtras.extra_maxcount else {
            number += 1
            optionCount.text = String(number)
            clickListner?.tapNonAdd(extraPrice: nonEssentialExtras.extra_price,selected: nonEssentialExtras)
            return
        }
        
    }
    @IBAction func AbstractCount(_ sender: Any) {
        var number : Int = Int(optionCount.text!)!
        guard number == 0 else {
            number -= 1
            optionCount.text = String(number)
            clickListner?.tapNonAbs(extraPrice: nonEssentialExtras.extra_price,selected : nonEssentialExtras)
            return
        }
    }
}

protocol CellDelegateNonExtra {
    func tapNonAdd ( extraPrice: Int,selected: Extra)
    func tapNonAbs ( extraPrice: Int,selected: Extra)
}


