//
//  AboutStore.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//


import UIKit
private let FirstBarIdentifier = "ASFirstBarCell"
class AboutStore : UIViewController {

    @IBOutlet weak var FirstPage: UICollectionView!
    @IBOutlet weak var FirstBar: UICollectionView!
    
    private let netWork = CallRequest()
    private let urlMaker = NetWorkURL()
    private var menus = [Menu]()
    private var StoreInfo = StoreInfoModel()
    private var categories = Dictionary<Int,String>()
    public var union = [String : [Menu]]()
    public var first = ["메뉴 정보","가게 정보"]
    private var storeInfoManager = StoreInfoController()
    private var storeMenuManager = StoreMenuController()
    private var contollers = [UIViewController]()
    public override func viewDidLoad() {
        super.viewDidLoad()
        storeInfoManager.netWork = netWork
        storeInfoManager.urlMaker = urlMaker
        contollers.append(storeMenuManager)
        contollers.append(storeInfoManager)
        netWork.get(method: .get, url: urlMaker.categoryURL + "?store_id=1") { (json) in
            if json["result"].boolValue{
                for item in json["category"].array!{
                    self.categories[item["category_id"].intValue] = item["category_name"].stringValue
                    self.union[item["category_name"].stringValue] = [Menu]();
                }
                self.netWork.get(method: .get, url: self.urlMaker.menuURL + "?store_id=1") { (json) in
                    let boolValue = json["result"].boolValue
                    if boolValue {
                        var tempMenu = Menu()
                        let jsonObject = json["menu"].array!
                        for item in jsonObject {
                            tempMenu.menu_defaultprice = item["menu_defaultprice"].intValue
                            tempMenu.menu_id = item["menu_id"].intValue
                            tempMenu.category_id = item["category_id"].intValue
                            tempMenu.menu_image = item["menu_image"].stringValue
                            tempMenu.store_id = item["store_id"].intValue
                            tempMenu.menu_name = item["menu_name"].stringValue
                            tempMenu.menu_info = item["menu_info"].stringValue
                            tempMenu.is_soldout = item["is_soldout"].stringValue
                            self.menus.append(tempMenu)
                            self.union[self.categories[tempMenu.category_id]!]?.append(tempMenu)
                        }
                        self.FirstBar.delegate = self
                        self.FirstBar.dataSource = self
                        self.FirstBar.reloadData()
                        self.netWork.get(method: .get, url: "http://15.165.22.64:8080/StoreFindById.do?store_id=1") {(json) in
                            self.StoreInfo.store_id = json["store_id"].intValue
                            self.StoreInfo.store_opentime = json["store_opentime"].stringValue
                            self.StoreInfo.store_latitude = json["store_latitude"].doubleValue
                            self.StoreInfo.store_closetime = json["store_closetime"].stringValue
                            self.StoreInfo.store_daysoff = json["store_daysoff"].stringValue
                            self.StoreInfo.message = json["message"].stringValue
                            self.StoreInfo.result = json["result"].boolValue
                            self.StoreInfo.store_phone = json["store_phone"].stringValue
                            self.StoreInfo.store_longitude = json["store_longitude"].doubleValue
                            self.StoreInfo.store_name = json["store_name"].stringValue
                            self.StoreInfo.store_location = json["store_location"].stringValue
                            self.StoreInfo.type_code = json["type_code"].stringValue
                            self.StoreInfo.store_image = json["store_image"].stringValue
                            self.StoreInfo.is_open = json["is_open"].stringValue
                            self.StoreInfo.store_info = json["store_info"].stringValue
                             
                        }
                    }else{
                        
                        
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(index)")
        actionToSelectedCell(indexPath: indexPath)
    }
    func actionToSelectedCell(indexPath : IndexPath){
        switch indexPath.row {
                case 0:
                    setContainerViewController(storyboard: "AboutStore", viewControllerID: "StoreMenuController",index: indexPath.row)
                case 1:
                    setContainerViewController(storyboard: "AboutStore", viewControllerID: "StoreInfoController",index: indexPath.row)
                default:
                    print("-touchUP\(indexPath.row)-")
                }
        }
    func setContainerViewController(storyboard: String, viewControllerID: String,index : Int){
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: viewControllerID)
//        let VC = contollers[index]
        switch index {
        case 0:
            (VC as! StoreMenuController).categories = self.categories
            (VC as! StoreMenuController).menus = self.union
            break
        case 1:
            (VC as! StoreInfoController).StoreInfo = self.StoreInfo
            break
            
        default: break
        }
            self.addChild(VC)
            FirstPage.addSubview((VC.view)!)
            VC.view.frame = FirstPage.bounds
            VC.didMove(toParent: self)
        }
}

extension AboutStore : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return first.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FirstBar.dequeueReusableCell(withReuseIdentifier: FirstBarIdentifier,for: indexPath) as! ASFirstStoreCell
        cell.state.setTitle(first[indexPath.row], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / CGFloat(first.count)*0.97),height: FirstBar.frame.height)
    }
}

struct StoreInfoModel {
    var store_id = 0
    var store_opentime = ""
    var store_info = ""
    var store_latitude = 0.0
    var store_closetime = "22:00"
    var store_daysoff = "매주 월, 화 휴무"
    var message = "가게 정보 가져오기 성공."
    var result = false
    var store_phone = "01000000000"
    var store_longitude = 0.0
    var store_name  = "test cafe"
    var store_location = "서울특별시 테스트구 테스트동 테스트로 111 테스트빌딩 2층"
    var type_code = "CAFE"
    var store_image = "test_cafe1.png"
    var is_open = "N"
}
