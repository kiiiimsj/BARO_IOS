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
    var location : Location?
    let bottomTabBarInfo = BottomTabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if UserDefaults.standard.object(forKey: "location") != nil{
            if let data = UserDefaults.standard.value(forKey: "location") as? Data{
                let decoderUserInfo = try? PropertyListDecoder().decode(Location.self, from: data)
                location = decoderUserInfo!
            }
        }
        if(kind == 1) { //mainpage에서 넘어온 페이지일 경우
            var jsonObject = [String : Any]()
            if location != nil {
                jsonObject["type_code"] = typeCode
                jsonObject["latitude"] = location?.latitude
                jsonObject["longitude"] = location?.longitude
            } else{
                jsonObject["type_code"] = typeCode
                jsonObject["latitude"] = NewMainPageController.DEFAULTLATITUDE
                jsonObject["longitude"] = NewMainPageController.DEFAULTLONGITUDE
            }
            network.post(method: .post, param: jsonObject, url: urlCaller.storeDetailListURL) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "", discount_rate: 0)
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
                    self.storeListView.reloadData()
                }
            }
            typeCode = ""
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        if kind == 2 { //favorite list 에서 넘어온 페이지일 경우
            storeList.removeAll()
            var jsonObject = [String : Any]()
            if location != nil {
                jsonObject["phone"] = UserDefaults.standard.value(forKey: "user_phone") as! String
                jsonObject["latitude"] = location?.latitude
                jsonObject["longitude"] = location?.longitude
            } else{
                jsonObject["phone"] = UserDefaults.standard.value(forKey: "user_phone") as! String
                jsonObject["latitude"] = NewMainPageController.DEFAULTLATITUDE
                jsonObject["longitude"] = NewMainPageController.DEFAULTLONGITUDE
            }
            network.post(method: .post, param: jsonObject, url: urlCaller.myStoreList) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "", discount_rate: 0)
                if json["result"].boolValue {
                    for item in json["favorite"].array! {
                        storeListModel.store_image = item["store_image"].stringValue
                        storeListModel.is_open = item["is_open"].stringValue
                        storeListModel.distance = item["distance"].doubleValue
                        storeListModel.store_id = item["store_id"].intValue
                        storeListModel.store_info = item["store_info"].stringValue
                        storeListModel.store_location = item["store_location"].stringValue
                        storeListModel.store_name = item["store_name"].stringValue
                        storeListModel.discount_rate = item["discount_rate"].intValue
                        self.storeList.append(storeListModel)
                    }
                    
                }else{
                    
                }
                self.storeListView.reloadData()
            }
        } else if kind == 3{  //kind == 3   -> search에서 넘어온 페이지일 경우
            var jsonObject = [String : Any]()
            if location != nil {
                jsonObject["startPoint"] = 0
                jsonObject["keyword"] = searchWord
                jsonObject["latitude"] = location?.latitude
                jsonObject["longitude"] = location?.longitude
            } else{
                jsonObject["startPoint"] = 0
                jsonObject["keyword"] = searchWord
                jsonObject["latitude"] = NewMainPageController.DEFAULTLATITUDE
                jsonObject["longitude"] = NewMainPageController.DEFAULTLONGITUDE
            }
            network.post(method: .post, param: jsonObject, url: urlCaller.storeSearchURL ) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "",discount_rate: 0)
                if json["result"].count < 20 {
                    self.endOfData = true
                }
                if json["result"].boolValue {
                    self.storeList.removeAll()
                    print("hty",json)
                    for item in json["store"].array! {
                        storeListModel.store_image = item["store_image"].stringValue
                        storeListModel.is_open = item["is_open"].stringValue
                        storeListModel.distance = item["distance"].doubleValue
                        storeListModel.store_id = item["store_id"].intValue
                        storeListModel.store_info = item["store_info"].stringValue
                        storeListModel.store_location = item["store_location"].stringValue
                        storeListModel.store_name = item["store_name"].stringValue
                        storeListModel.discount_rate = item["discount_rate"].intValue
                        self.storeList.append(storeListModel)
                    }
                }else{
                    self.endOfData = true
                }
                self.storeListView.reloadData()
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    func configureView(){
        view.backgroundColor = .white
        storeListView.backgroundColor = .white
        storeListView.delegate = self
        storeListView.dataSource = self
    }
    func toStoreListUseBottomBar(id : Int) {
        network.get(method: .get, url: urlCaller.reloadStoreDiscount + String(id as! Int)) { [self] json in
            if json["result"].boolValue {
                let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
                let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
                
                ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.aboutStoreControllerIdentifier
                ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.aboutStoreStoryBoard
                ViewInBottomTabBar.controllerSender = ["id" : id, "discount_rate" : json["discount_rate"].intValue]
                ViewInBottomTabBar.moveFromOutSide = true
                ViewInBottomTabBar.modalPresentationStyle = .fullScreen
                ViewInBottomTabBar.modalTransitionStyle = .crossDissolve
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                view.window?.layer.add(transition, forKey: kCATransition)
                self.present(ViewInBottomTabBar, animated: true, completion: nil)
        //        navigationController?.pushViewController(ViewInBottomTabBar, animated: false)
            }else{
                return
            }
        }
        
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
        }
        else{
            return storeList.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if endOfData {
            return 1
        }
        
        if kind == 3 && callMoreData {
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
            cell.imageView.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + String(store.store_image)))
            if store.is_open == "Y" {
                cell.is_OpenLable.text = "영업중"
                cell.is_OpenLable.backgroundColor = UIColor.baro_main_color
            }else{
                cell.is_OpenLable.text = "준비중"
                cell.is_OpenLable.backgroundColor = UIColor.init(cgColor: CGColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1))
            }
            if store.discount_rate != 0 {
                cell.discount_rate_label.text = "SALE \(store.discount_rate)%"
                cell.discount_rate_label.isHidden = false
            }else{
                cell.discount_rate_label.isHidden = true
            }
            if store.discount_rate != 0 {
                cell.discount_rate_label.text = "SALE \(store.discount_rate)%"
                cell.discount_rate_label.isHidden = false
            }else{
                cell.discount_rate_label.isHidden = true
            }
            cell.is_OpenLable.layer.borderColor = UIColor.white.cgColor
            cell.is_OpenLable.layer.borderWidth = 2
            cell.is_OpenLable.layer.cornerRadius = 5
            cell.is_OpenLable.layer.masksToBounds = true
            if Int(store.distance) > 1000 {
                cell.distance_Label.text = String(Double(Int(store.distance/100) / 10)) + "km"
            }else{
                cell.distance_Label.text = String(Int(store.distance)) + "m"
            }
            
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = storeList[indexPath.item].store_id
        let storeName = String(storeList[indexPath.item].store_name)
        UserDefaults.standard.set(storeName, forKey: "currentStoreName")
        self.toStoreListUseBottomBar(id : id)
    }
    
}

extension StoreListPageController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (storeListView.contentSize.height-100 - storeListView.frame.size.height) && kind == 3{
            if !callMoreData {
                loadData()
            }
                
        }
    }
    func loadData() {
        callMoreData = true
        var jsonObject = [String : Any]()
        if location != nil {
            jsonObject["startPoint"] = startPoint
            jsonObject["keyword"] = searchWord
            jsonObject["latitude"] = location?.latitude
            jsonObject["longitude"] = location?.longitude
        } else{
            jsonObject["startPoint"] = startPoint
            jsonObject["keyword"] = searchWord
            jsonObject["latitude"] = NewMainPageController.DEFAULTLATITUDE
            jsonObject["longitude"] = NewMainPageController.DEFAULTLONGITUDE
        }
        network.post(method: .post, param: jsonObject, url: urlCaller.storeSearchURL ) {
            (json) in
            var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "",discount_rate: 0)
            if json["result"].boolValue {
                self.storeListView.reloadData()
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
                self.callMoreData = false
                self.storeListView.reloadData()
            }
            else {
                self.endOfData = true
            }
            self.callMoreData = false
        }
    }
}

extension StoreListPageController {
    func reloadStoreList() {
        switch kind {
        case 2:
            storeList.removeAll()
            var jsonObject = [String : Any]()
            if location != nil {
                jsonObject["phone"] = UserDefaults.standard.value(forKey: "user_phone") as! String
                jsonObject["latitude"] = location?.latitude
                jsonObject["longitude"] = location?.longitude
            } else{
                jsonObject["phone"] = UserDefaults.standard.value(forKey: "user_phone") as! String
                jsonObject["latitude"] = NewMainPageController.DEFAULTLATITUDE
                jsonObject["longitude"] = NewMainPageController.DEFAULTLONGITUDE
            }
            network.post(method: .post, param: jsonObject, url: urlCaller.myStoreList) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "", discount_rate: 0)
                if json["result"].boolValue {
                    for item in json["favorite"].array! {
                        storeListModel.store_image = item["store_image"].stringValue
                        storeListModel.is_open = item["is_open"].stringValue
                        storeListModel.distance = item["distance"].doubleValue
                        storeListModel.store_id = item["store_id"].intValue
                        storeListModel.store_info = item["store_info"].stringValue
                        storeListModel.store_location = item["store_location"].stringValue
                        storeListModel.store_name = item["store_name"].stringValue
                        storeListModel.discount_rate = item["discount_rate"].intValue
                        self.storeList.append(storeListModel)
                    }
                    
                }else{
                    
                }
                self.storeListView.reloadData()
                BottomTabBarController.activityIndicator.stopAnimating()
            }
        case 3 :
            storeList.removeAll()
            var jsonObject = [String : Any]()
            if location != nil {
                jsonObject["startPoint"] = 0
                jsonObject["keyword"] = searchWord
                jsonObject["latitude"] = location?.latitude
                jsonObject["longitude"] = location?.longitude
            } else{
                jsonObject["startPoint"] = 0
                jsonObject["keyword"] = searchWord
                jsonObject["latitude"] = NewMainPageController.DEFAULTLATITUDE
                jsonObject["longitude"] = NewMainPageController.DEFAULTLONGITUDE
            }
            network.post(method: .post, param: jsonObject, url: urlCaller.storeSearchURL ) {
                (json) in
                var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "",discount_rate: 0)
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
                        storeListModel.discount_rate = item["discount_rate"].intValue
                        self.storeList.append(storeListModel)
                    }
                }else{
                    self.endOfData = true
                }
                self.storeListView.reloadData()
                BottomTabBarController.activityIndicator.stopAnimating()
            }
        default:
            return
        }
    }
    @objc func willEnterForeground() {
        reloadStoreList()
    }
}
