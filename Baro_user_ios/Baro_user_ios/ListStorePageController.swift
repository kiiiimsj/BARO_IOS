//
//  ListStoreController.swift
//  BARO_USER
//
//  Created by . on 2020/10/15.
//

import UIKit
private let StorelistCellIdentifier = "StoreListCell"
private let ListStorePageIdentifier = "ListStoreController"
class ListStoreController : UIViewController{
    @IBOutlet weak var storeListView: UICollectionView!
    var storeList = [StoreList]()
    let network = CallRequest()
    let urlCaller = NetWorkURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let jsonObject : [String : Any ] = [
            "type_code" : "CAFE",
            "latitude" : "37.499",
            "longitude" : "126.956"
        ]
        network.post(method: .post, param: jsonObject, url: urlCaller.storeDetailListURL) {(json) in
            print(json)
            var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "")
            for item in json["store"].array!{
                storeListModel.store_image = item["store_image"].stringValue
                storeListModel.is_open = item["is_open"].stringValue
                storeListModel.distance = item["distance"].doubleValue
                storeListModel.store_id = item["store_id"].intValue
                storeListModel.store_info = item["store_info"].stringValue
                storeListModel.store_location = item["store_location"].stringValue
                storeListModel.store_name = item["store_name"].stringValue
                self.storeList.append(storeListModel)
            }
            self.storeListView.reloadData()
        }
    }
    func configureView(){
        view.backgroundColor = .red
        storeListView.backgroundColor = .white
        storeListView.delegate = self
        storeListView.dataSource = self
        
        
    }
    
    
}

extension ListStoreController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let store = storeList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorelistCellIdentifier, for: indexPath) as! StoreListCell
        cell.textLabel.text = String(store.store_name)
        cell.imageView.kf.setImage(with: URL(string: "http://15.165.22.64:8080/ImageStore.do?image_name=" + String(store.store_image)))
        if store.is_open == "Y" {
            cell.is_OpenLable.text = "영업중"
        }else{
            cell.is_OpenLable.text = "영업종료"
        }
        cell.distance_Label.text = String(Int(store.distance)) + "m"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left:0, bottom: 10, right:0)
    }
    
    
}