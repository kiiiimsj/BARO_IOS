//
//  MainPageTypeCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit
import Kingfisher


protocol CellDelegateType: class {
    func tapClickType(tag: String)
}

class MainPageType : UICollectionViewCell {
    
    var delegateType: CellDelegateType?

    var typeList = [TypeListModel]()
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()

   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configure()
    }
    
    func configure(){
        networkModel.post(method: .get, url: networkURL.typeListURL) { [self] json in
            var typeModel = TypeListModel()
            print("zz", json)
            for item in json["type"].array! {
                typeModel.type_code = item["type_code"].stringValue
                typeModel.type_name = item["type_name"].stringValue
                typeModel.type_image = item["type_image"].stringValue
                self.typeList.append(typeModel)
            }

            self.collectionView.reloadData()
            let contentSizeHeight = CGFloat(self.typeList.count / 4 * 100 + 100)
            let contentSize = CGSize(width: collectionView.frame.width, height: 300)
            self.collectionView.contentSize = contentSize
            
        }
    }
    
}

extension MainPageType : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("zzz", typeList.count)
        return typeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = typeList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageTypeCell", for: indexPath) as! MainPageTypeCell
        cell.typeName.text = type.type_name
        cell.typeImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageType.do?image_name=" + type.type_image))
      
        //클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
         
        return cell
    }
    
    
    //type클릭시 이벤트
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let typeCode = typeList[indexPath!.row].type_code
        if let index = indexPath {
            print("tap!! index : \(typeCode)")
            delegateType?.tapClickType(tag: typeCode)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("찍",collectionView.frame.width)
        return CGSize(width: collectionView.frame.width / 4 - 1, height: 100)
    }
}

