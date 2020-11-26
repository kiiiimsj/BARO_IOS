//
//  BasketMenuCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit

protocol BasketMenuCellDelegate : AnyObject {
    func btnDeleteTapped(cell : BasketMenuCell)
}
class BasketMenuCell: UICollectionViewCell {
    var essential : [Extra]?
    var nonEssential : [SelectedExtra]?
    @IBOutlet weak var extraCollectionView: UICollectionView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_defaultPrice: UILabel!
    @IBOutlet weak var menu_extra_sum: UILabel!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var menu_totalPrice: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate : BasketMenuCellDelegate?
    var eachMenu : Order?
        
        override func prepareForReuse() {
            super.prepareForReuse()
            print("prepare")
            nonEssential = nil
            eachMenu = nil
            essential = nil
            menu_name.text = ""
            menu_defaultPrice.text = ""
            menu_extra_sum.text = ""
            menu_count.text = ""
            menu_totalPrice.text = ""
        }
    
    @IBAction func deleteBUttonClikc(_ sender : AnyObject) {
        delegate?.btnDeleteTapped(cell: self)
        
    }
}

extension BasketMenuCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if essential!.count == 0{
                return 0
            }else{
                return 1 // 필수 옵션
            }
        case 1:
            return nonEssential!.count // 비필수
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
            for item in essential! {
                sum += item.extra_price
                name += item.extra_name+"/"
            }
            if essential!.count > 0  {
                cell.extraPrice.text = String(sum)
                let endIdx = name.index(name.startIndex, offsetBy: name.count-2)
                cell.extraNames.text = String(name[...endIdx])
            }
            return cell
        case 1:
            let cell = extraCollectionView.dequeueReusableCell(withReuseIdentifier: "BasketNonEssentialCell", for: indexPath) as! BasketNonEssentialCell
            if nonEssential!.count > indexPath.item{
            let values = nonEssential![indexPath.item]
            //            let values = Array(eachMenu.nonEssentials)[indexPath.item].value
            cell.extra_name.text =  values.Extra?.extra_name
            cell.extra_count.text = String(values.optionCount)
            cell.extra_price.text = String(values.Extra!.extra_price * values.optionCount)
            
            }else{
                print("out of")
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: extraCollectionView.frame.width, height: 48)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}
