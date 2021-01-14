//
//  MainPageNewStore.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/21.
//

import UIKit

protocol CellDelegateNewStore: class {
    func tapClickNewStore(tag: Int)
}

class MainPageNewStore : UICollectionViewCell {
    
    var delegateNewStore : CellDelegateNewStore?
    
    var newStoreList = [NewStoreListModel]()
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let jsonObject : [String : Any ] = [
        "latitude" : "10.11",
        "longitude" : "10.22"
        ]
        
        networkModel.post(method: .post, param: jsonObject, url: networkURL.newStoreList) { (json) in
            var newStoreModel = NewStoreListModel()
            if json["result"].boolValue {
                for item in json["store"].array! {
                    newStoreModel.store_name = item["store_name"].stringValue
                    newStoreModel.store_info = item["store_info"].stringValue
                    newStoreModel.store_image = item["store_image"].stringValue
                    newStoreModel.store_id = item["store_id"].intValue
                    newStoreModel.distance = item["distance"].stringValue
                    newStoreModel.is_open = item["is_open"].stringValue
                    self.newStoreList.append(newStoreModel)
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension MainPageNewStore : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newStoreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newStore = newStoreList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageNewStoreCell", for: indexPath) as! MainPageNewStoreCell
        cell.newStoreName.text = newStore.store_name
        cell.newStoreImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + newStore.store_image))
        if Double(newStore.distance)! > 1000 {
            cell.newStoreDistance.text = String(Int(Double(newStore.distance)!)/1000) + " km"
        }else{
            cell.newStoreDistance.text = String(Int(newStore.distance)!) + " m"
        }
        if newStore.is_open == "Y" {
            cell.newStore_isOpen.text = "영업중"
            cell.newStore_isOpen.backgroundColor = .baro_main_color
        }else{
            cell.newStore_isOpen.backgroundColor = .customLightGray
        }
        // 버튼 테두리 둥글게
        cell.newStore_isOpen.layer.cornerRadius = 10
        cell.newStore_isOpen.layer.borderColor = UIColor.white.cgColor
        cell.newStore_isOpen.layer.borderWidth = 2
        cell.newStore_isOpen.layer.masksToBounds = true
        //cell 클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
        
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let newStoreId = newStoreList[indexPath!.row].store_id
        print("new store!! index : \(newStoreId)")
        UserDefaults.standard.set(newStoreList[indexPath!.row].store_name, forKey: "currentStoreName")
        delegateNewStore?.tapClickNewStore(tag: newStoreId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 200)
    }
    
}
