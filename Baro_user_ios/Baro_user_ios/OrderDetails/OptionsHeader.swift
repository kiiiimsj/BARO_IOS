//
//  OptionsHeader.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

class OptionsHeader: UICollectionReusableView {
    @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var header: UILabel!
    var iPath = IndexPath()
    var expandable = false
    var open = false
    var clickListener : ExpandDelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
//        if expandable {
//            arrow.isHidden = !expandable
//        }
    }
    @IBAction func expand(_ sender: Any) {
        open = !open
        if open {
            let image = UIImage(named: "heart")
            arrow.setImage(image, for: .normal)
            
        }else{
            let image = UIImage(named: "arrow_down")
            arrow.setImage(image, for: .normal)
        }
       
        print("open?",open)
        clickListener?.clickExpand(open: open,iPath: iPath)
    }
}

protocol ExpandDelegate {
    func clickExpand(open : Bool,iPath : IndexPath)
}
