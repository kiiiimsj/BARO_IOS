//
//  MainPageUltraStore.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

class MainPageUltraStore : UITableViewCell {
    
    var ultraList = [UltraStoreListModel]()
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        networkModel.post(method: .post, url: networkURL.ultraList) { json in
            var ultraModel = UltraStoreListModel()
            for item in json["ultra"].array! {
                ultraModel.store_name = item["store_name"].stringValue
                ultraModel.store_info = item["store_info"].stringValue
                ultraModel.store_image = item["store_image"].stringValue
                
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
        //cell에 추가해주기
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
}
