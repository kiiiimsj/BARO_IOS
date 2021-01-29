//
//  MainPageUltraStore.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

protocol CellDelegateUltra: class {
    func tapClickUltra(tag: Int)
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
            if json["result"].boolValue {
                for item in json["store"].array! {
                    ultraModel.store_name = item["store_name"].stringValue
                    ultraModel.store_info = item["store_info"].stringValue
                    ultraModel.store_image = item["store_image"].stringValue
                    ultraModel.store_id = item["store_id"].intValue
                    ultraModel.distance = item["distance"].stringValue
                    ultraModel.is_open = item["is_open"].stringValue
                    self.ultraList.append(ultraModel)
                }
                self.collectionView.reloadData()
            }
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
        if Double(ultra.distance)! > 1000 {
            cell.ultraDistance.text = String(Int(Double(ultra.distance)!)/1000) + " km"
        }else{
            cell.ultraDistance.text = String(Int(ultra.distance)!) + " m"
        }
       
        cell.ultraImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/UltraNewImageStore.do?image_name="+ultra.store_image))
        cell.ultra_isOpen.layer.cornerRadius = 8
        if ultra.is_open == "Y" {
            cell.ultra_isOpen.text = "영업중"
            cell.ultra_isOpen.backgroundColor = .baro_main_color
        }else{
            cell.ultra_isOpen.backgroundColor = .customLightGray
        }
        // 버튼 테두리 둥글게
        cell.ultra_isOpen.layer.cornerRadius = 10
        cell.ultra_isOpen.layer.borderColor = UIColor.white.cgColor
        cell.ultra_isOpen.layer.borderWidth = 2
        cell.ultra_isOpen.layer.masksToBounds = true
        
        //cell 클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            let storeId = ultraList[index.row].store_id
            UserDefaults.standard.set(ultraList[index.row].store_name, forKey: "currentStoreName")
            delegateUltra?.tapClickUltra(tag: storeId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 250)
    }
}
