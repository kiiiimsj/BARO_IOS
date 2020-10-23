//
//  MainPageNewStore.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/21.
//

import UIKit

protocol CellDelegateNewStore: class {
    func tapClickNewStore(tag: String)
}

class MainPageNewStore : UITableViewCell {
    
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
            for item in json["store"].array! {
                newStoreModel.store_name = item["store_name"].stringValue
                newStoreModel.store_info = item["store_info"].stringValue
                newStoreModel.store_image = item["store_image"].stringValue
                newStoreModel.store_id = item["store_id"].stringValue
                
                self.newStoreList.append(newStoreModel)
            }
            self.collectionView.reloadData()
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
        cell.newStoreInfo.text = newStore.store_info
        cell.newStoreImage.kf.setImage(with: URL(string: "http://15.165.22.64:8080/ImageStore.do?image_name=" + newStore.store_image))
        
        //cell 클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
        
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let newStoreId = newStoreList[indexPath!.row].store_id
        if let index = indexPath {
            print("new store!! index : \(newStoreId)")
            delegateNewStore?.tapClickNewStore(tag: newStoreId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 200)
    }
    
}
