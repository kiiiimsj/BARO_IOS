//
//  EssentialCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

class EssentialCell : UICollectionViewCell{
    @IBOutlet weak var collection: UICollectionView!
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
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collection.frame.width/CGFloat(extras.count), height:100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OptionCategoryHeader", for: indexPath) as! OptionCategoryHeader
        if extras.count != 0 {
            headerview.OptionCategory.text = extras[0].extra_group
        }
        return headerview
      }
    
}
