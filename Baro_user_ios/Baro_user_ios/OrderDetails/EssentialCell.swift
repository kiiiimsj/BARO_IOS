//
//  EssentialCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

protocol CellDelegateExtra: class {
    func click(extra_name : String ,extraPrice: Int)
}

class EssentialCell : UICollectionViewCell{
    @IBOutlet weak var collection: UICollectionView!
    var clickListener : CellDelegateExtra?
    public var extras = [Extra]()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EssentialButton", for: indexPath) as! EssentialButton
        print("abc",extras[indexPath.item].extra_name)
        cell.menu.setTitle(extras[indexPath.item].extra_name, for: .normal)
        cell.backgroundColor = .yellow
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collection.frame.width/CGFloat(extras.count+1), height:100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OptionCategoryHeader", for: indexPath) as! OptionCategoryHeader
        if extras.count != 0 {
            headerview.optionCategory.text = extras[0].extra_group
        }
        return headerview
      }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collection)
        let indexPath = self.collection.indexPathForItem(at: location)
        print("ppp")
        if let index = indexPath {
            print("lll")
            let data = extras[index.item]
            print("tap!! index : " + data.extra_name)
            clickListener?.click(extra_name: data.extra_name, extraPrice: data.extra_price)
        }
    }
}
