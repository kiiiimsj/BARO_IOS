//
//  MainPageTypeCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit
import Kingfisher


class MainPageType : UITableViewCell {
    
    
    var typeList = [TypeListModel]()
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        networkModel.post(method: .get, url: networkURL.typeListURL) { json in
            var typeModel = TypeListModel()
            for item in json["type"].array! {
                typeModel.type_code = item["type_code"].stringValue
                typeModel.type_name = item["type_name"].stringValue
                typeModel.type_image = item["type_image"].stringValue
                self.typeList.append(typeModel)
            }

            self.collectionView.reloadData()
        }
    }
}

extension MainPageType : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = typeList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageTypeCell", for: indexPath) as! MainPageTypeCell
        cell.typeName.text = type.type_name
        cell.typeImage.kf.setImage(with: URL(string: "http://15.165.22.64:8080/ImageType.do?image_name=" + type.type_image))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 100, height: 90)
    }

}
