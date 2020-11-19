//
//  ListStoreController.swift
//  BARO_USER
//
//  Created by . on 2020/10/15.
//

import UIKit
private let StorelistCellIdentifier = "StoreListCell"
private let ListStorePageIdentifier = "StoreListPageController"
class StoreListPageController : UIViewController {
    
    @IBOutlet weak var storeListView: UICollectionView!
    var storeList = [StoreList]()
    let network = CallRequest()
    let urlCaller = NetWorkURL()
    
    //전 페이지(MainPage -> 1 / favorite -> 2 / search -> 3 (kind의 값)
    var kind = 0
    var startPoint = 0 // search 일때만 사용하는 값
    var callMoreData = false
    var endOfData = false
    //전 페이지에서 받아와야할 값
    var typeCode = ""
    var searchWord = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        if(kind == 1) { //mainpage에서 넘어온 페이지일 경우
            let jsonObject : [ String : Any ] = [
                "type_code" : typeCode,
                "latitude" : "37.499",
                "longitude" : "126.956"
            ]
            network.post(method: .post, param: jsonObject, url: urlCaller.storeDetailListURL) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "")
                for item in json["store"].array! {
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
            typeCode = ""
        }
        else if kind == 2 { //favorite list 에서 넘어온 페이지일 경우
            
        }
        
        else if kind == 3{  //kind == 3   -> search에서 넘어온 페이지일 경우
            let jsonObject : [String : Any ] = [
                "keyword" : searchWord,
                "latitude" : "37.499",
                "longitude" : "126.956",
                "startPoint" : 0
            ]
            network.post(method: .post, param: jsonObject, url: urlCaller.storeSearchURL ) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "")
                if json["result"].count < 20 {
                    self.endOfData = true
                }
                if json["result"].boolValue {
                    for item in json["store"].array! {
                        storeListModel.store_image = item["store_image"].stringValue
                        storeListModel.is_open = item["is_open"].stringValue
                        storeListModel.distance = item["distance"].doubleValue
                        storeListModel.store_id = item["store_id"].intValue
                        storeListModel.store_info = item["store_info"].stringValue
                        storeListModel.store_location = item["store_location"].stringValue
                        storeListModel.store_name = item["store_name"].stringValue
                        self.storeList.append(storeListModel)
                    }
                }else{
                    self.endOfData = true
                    
                }
                self.storeListView.reloadData()
            }
            self.storeListView.reloadData()
        }
        else {
            
        }
        
    }
    func configureView(){
        view.backgroundColor = .white
        storeListView.backgroundColor = .white
        storeListView.delegate = self
        storeListView.dataSource = self
    }
}

extension StoreListPageController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if kind == 3 {
            if section == 1 {
                if endOfData {
                    return 0
                }
                else{
                    return 1
                }
            }else{
                return storeList.count
            }
        }else{
            return storeList.count
        }
       
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if endOfData {
            return 1
        }
        else if kind == 3 {
            return 2
        }else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 && endOfData {
            return UICollectionViewCell()
        }
        if indexPath.section == 1 && kind == 3  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! ListStoreLoadingCell
            cell.loading.startAnimating()
            return cell
        }else{
            let store = storeList[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorelistCellIdentifier, for: indexPath) as! StoreListCell
            cell.textLabel.text = String(store.store_name)
            print("stoima", store.store_image)
            cell.imageView.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + String(store.store_image)))
            if store.is_open == "Y" {
                cell.is_OpenLable.text = "영업중"
            }else{
                cell.is_OpenLable.text = "영업종료"
            }
            cell.distance_Label.text = String(Int(store.distance)) + "m"
            return cell
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextViewController = segue.destination as? AboutStore {
            let labell = sender as! String
            nextViewController.store_id = labell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = String(storeList[indexPath.item].store_id)
        navigationController?.pushViewController(AboutStore(), animated: false)
        performSegue(withIdentifier: "toAboutStore", sender: id)
    }
    
}

extension StoreListPageController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (storeListView.contentSize.height-100 - storeListView.frame.size.height) && kind == 3{
            if !callMoreData {
                loadData()
                print("ddddd",startPoint)
            }
            
        }
    }
    func loadData() {
        callMoreData = true
        
        let jsonObject : [String : Any ] = [
            "keyword" : searchWord,
            "latitude" : "37.499",
            "longitude" : "126.956",
            "startPoint" : startPoint
        ]
        print("point",startPoint)
        network.post(method: .post, param: jsonObject, url: urlCaller.storeSearchURL ) {
            (json) in
            var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "")
            if json["result"].boolValue {
                self.storeListView.reloadSections(IndexSet(integer: 1))
                print(json)
                for item in json["store"].array! {
                    storeListModel.store_image = item["store_image"].stringValue
                    storeListModel.is_open = item["is_open"].stringValue
                    storeListModel.distance = item["distance"].doubleValue
                    storeListModel.store_id = item["store_id"].intValue
                    storeListModel.store_info = item["store_info"].stringValue
                    storeListModel.store_location = item["store_location"].stringValue
                    storeListModel.store_name = item["store_name"].stringValue
                    self.storeList.append(storeListModel)
                }
                self.startPoint += 20
                self.storeListView.reloadData()
            }
            else {
                self.endOfData = true
            }
            self.callMoreData = false
        }
    }
}
