//
//  EssentialCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

protocol CellDelegateExtra: class {
    func click(extra_name : String ,extraPrice: Int,iPath:IndexPath)
    func radioClick(extra_name : String ,extraPrice: Int)
}
class EssentialCell : UICollectionViewCell{
    public static let UNDER3 = "EssentialCell"
    public static let OVER3 = "EssentialRadio"
        @IBOutlet weak var optionCategory: UILabel!
    @IBOutlet weak var selectedOption: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    var whichCell = ""
    var exSelectedPrice = 0
    var essentialCollector = [IndexPath]()
    var clickListener : CellDelegateExtra?
    public var extras = [Extra]()
    public var iPath : IndexPath?
    public var n = 1
    var header :OptionCategoryHeader?
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        collection.delegate = self
//        collection.dataSource = self
    }
    
}

extension EssentialCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("zzzz",extras.count)
        return extras.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch whichCell {
        case EssentialCell.UNDER3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EssentialButton", for: indexPath) as! EssentialButton
            cell.menu.backgroundColor = .purple
            cell.menu.adjustsImageWhenHighlighted = false
            cell.menu.setTitleColor(.orange, for: .normal)
            cell.menu.setTitleColor(.purple, for: .selected)
            cell.menu.setTitle(extras[indexPath.item].extra_name, for: .normal)
    //        cell.backgroundColor = .yellow
            cell.menu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            cell.data = extras[indexPath.item]
            cell.menu.isSelected = false
            self.essentialCollector.append(indexPath)
            return cell
        case EssentialCell.OVER3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EssentialCell.OVER3, for: indexPath) as! EssentialRadio
            cell.optionName.text = extras[indexPath.item].extra_name
            cell.data = extras[indexPath.item]
            cell.radioBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap2(_:))))
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch whichCell {
        case EssentialCell.UNDER3:
            return CGSize(width: collection.frame.width/CGFloat(extras.count+1), height:50)
        case EssentialCell.OVER3:
            return CGSize(width: collection.frame.width, height:50)
        default:
            return CGSize()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OptionCategoryHeader", for: indexPath) as! OptionCategoryHeader
//        header = headerview
//        if extras.count != 0 {
//            headerview.optionCategory.text = extras[0].extra_group
//        }
//        return headerview
//      }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collection)
        let indexPath = self.collection.indexPathForItem(at: location)
        if let index = indexPath {
            let data = extras[index.item]
            let obj = self.collection.cellForItem(at: indexPath!) as! EssentialButton
            obj.menu.isSelected = !obj.menu.isSelected
            if obj.menu.isSelected == true{
                selectedOption.text = "\(data.extra_name) 선택(+\(data.extra_price))원 "
                for item in essentialCollector {
                    let otherOptions = self.collection.cellForItem(at: item) as! EssentialButton
                    if !otherOptions.isEqual(obj) {
                        otherOptions.menu.isSelected = false
                    } else{
                        
                    }
                }
                clickListener?.click(extra_name: data.extra_name, extraPrice: data.extra_price - exSelectedPrice,iPath: self.iPath!)
                exSelectedPrice = data.extra_price
            }else{
                clickListener?.click(extra_name: data.extra_name, extraPrice: -(data.extra_price),iPath: self.iPath!)
                exSelectedPrice = 0
                for item in essentialCollector {
                    let otherOptions = self.collection.cellForItem(at: item) as! EssentialButton
                    otherOptions.menu.isSelected = false
                }
                selectedOption.text = ""
               
            }
        }
    }
    @objc func tap2(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collection)
        let indexPath = self.collection.indexPathForItem(at: location)
        if let index = indexPath {
            let data = extras[index.item]
            let obj = self.collection.cellForItem(at: indexPath!) as! EssentialRadio
            obj.radioBtn.isSelected = !obj.radioBtn.isSelected
            if obj.radioBtn.isSelected == true{
                selectedOption.text = "\(data.extra_name) 선택(+\(data.extra_price))원 "
                for item in essentialCollector {
                    let otherOptions = self.collection.cellForItem(at: item) as! EssentialRadio
                    if !otherOptions.isEqual(obj) {
                        otherOptions.radioBtn.isSelected = false
                    } else{
                        
                    }
                }
                clickListener?.radioClick(extra_name: data.extra_name, extraPrice: data.extra_price - exSelectedPrice)
                exSelectedPrice = data.extra_price
            }else{
                clickListener?.radioClick(extra_name: data.extra_name, extraPrice: -(data.extra_price))
                exSelectedPrice = 0
                for item in essentialCollector {
                    let otherOptions = self.collection.cellForItem(at: item) as! EssentialRadio
                    otherOptions.radioBtn.isSelected = false
                }
                selectedOption.text = ""
            }
        }
    }
}
