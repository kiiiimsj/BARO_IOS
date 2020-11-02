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
            clickListner?.tapNonAdd(extra_name: nonEssentialExtras.extra_name, extraPrice: nonEssentialExtras.extra_price)
            return
        }
        
    }
    @IBAction func AbstractCount(_ sender: Any) {
        var number : Int = Int(optionCount.text!)!
        guard number == 0 else {
            number -= 1
            optionCount.text = String(number)
            clickListner?.tapNonAbs(extra_name: nonEssentialExtras.extra_name, extraPrice: nonEssentialExtras.extra_price)
            return
        }
    }
}

protocol CellDelegateNonExtra {
    func tapNonAdd (extra_name : String ,extraPrice: Int)
    func tapNonAbs (extra_name : String ,extraPrice: Int)
}


