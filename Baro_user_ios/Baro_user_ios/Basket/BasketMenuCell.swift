//
//  BasketMenuCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit

class BasketMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var extraCollectionView: UICollectionView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_defaultPrice: UILabel!
    @IBOutlet weak var menu_extra_sum: UILabel!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var menu_totalPrice: UILabel!
    var eachMenu : Order!
}

extension BasketMenuCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return eachMenu.nonEssentials.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = extraCollectionView.dequeueReusableCell(withReuseIdentifier: "BasketEssentialCell", for: indexPath) as! BasketEssentialCell
            var sum = 0
            var name = ""
            for item in eachMenu.Essentials {
                sum += item.value.extra_price
                name += item.value.extra_name+"/"
            }
            if eachMenu.Essentials.count > 0 {
                cell.extraPrice.text = String(sum)
                let endIdx = name.index(name.startIndex, offsetBy: name.count-2)
                cell.extraNames.text = String(name[...endIdx])
            }
            return cell
        case 1:
            let cell = extraCollectionView.dequeueReusableCell(withReuseIdentifier: "BasketNonEssentialCell", for: indexPath) as! BasketNonEssentialCell
            let values = Array(eachMenu.nonEssentials)[indexPath.row].value
            cell.extra_name.text = values.Extra?.extra_name
            cell.extra_count.text = String(values.optionCount)
            cell.extra_price.text = String(values.Extra!.extra_price)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: extraCollectionView.frame.width, height: 50)
    }
    
    
    
}
