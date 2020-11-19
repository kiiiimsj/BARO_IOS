//
//  MainPageUltraStore.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

protocol CellDelegateUltra: class {
    func tapClickUltra(tag: String)
}

class MainPageUltraStore : UICollectionViewCell {
    
    var delegateUltra : CellDelegateUltra?
    
    var ultraList = [UltraStoreListModel]()
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
        
        networkModel.post(method: .post, param: jsonObject, url: networkURL.ultraList) { (json) in
            var ultraModel = UltraStoreListModel()
            for item in json["store"].array! {
                ultraModel.store_name = item["store_name"].stringValue
                ultraModel.store_info = item["store_info"].stringValue
                ultraModel.store_image = item["store_image"].stringValue
                ultraModel.store_id = item["store_id"].stringValue
                
                self.ultraList.append(ultraModel)
            }
            self.collectionView.reloadData()
        }
        
    }
}

extension MainPageUltraStore : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ultraList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ultra = ultraList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageUltraStoreCell", for: indexPath) as! MainPageUltraStoreCell
        cell.ultraName.text = ultra.store_name
        print("qqq",ultra.store_name)
        cell.ultraDistance.text = "100m"
       
        cell.ultraImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name="+ultra.store_image))
        
        //cell 클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            let storeId = ultraList[indexPath!.row].store_id
            print("ultra tap!! index : \(storeId)")
            delegateUltra?.tapClickUltra(tag: storeId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 200)
    }
}
