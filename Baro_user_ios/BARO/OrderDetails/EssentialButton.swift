//
//  EssentialButton.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit
//protocol EssentialListner : class {
//    func change(extra_name : String ,extraPrice: Int,iPath:IndexPath)
//}
class EssentialButton : UICollectionViewCell{
    public var data = Extra()
    @IBOutlet weak var menu: EssentialBtn!
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
}

class EssentialBtn : UIButton{
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                self.backgroundColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1)
//                self.setTitleColor(.purple, for: .normal)
//                menu.titleLabel?.textColor = .purple
//            case false:
//                menu.backgroundColor = .purple
//                menu.titleLabel?.textColor = .orange
            default:
                self.backgroundColor = .white
//                self.setTitleColor(.orange, for: .normal)
            }
        }
    }
}
