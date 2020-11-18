//
//  AboutStore.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//


import UIKit
private let FirstBarIdentifier = "ASFirstBarCell"
class AboutStore : UIViewController , isClick {
    
    
    @IBOutlet weak var FirstPage: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var storeInfoButton: UIButton!
    @IBOutlet weak var tabIndecator: UIView!
    
    public var store_id  = ""
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var isFavoriteBtn: UIButton!
    private var isFlag : Int = 0
    
    private let netWork = CallRequest()
    private let urlMaker = NetWorkURL()
    private var menus = [Menu]()
    private var StoreInfo = StoreInfoModel()
    private var storeInfoManager = StoreInfoController()
    private var storeMenuManager = StoreMenuController()
    private var contollers = [UIViewController]()
    var setBottomTabBar = BottomTabBarController()
    public override func viewDidLoad() {
        super.viewDidLoad()
        settingBottomBar()
        setBottomTabBar.setBottomViewInOtherController(view: view, targetController: self, controller: setBottomTabBar)
        
        self.setTabBarItem()
        self.getStoreInfo()
        self.isFavoriteStore()
        
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
        UIView.animate(withDuration: 0.0) {
            self.tabIndecator.transform = CGAffineTransform(rotationAngle: 0.0)
        }
    }
    func setTabBarItem() {
        menuButton.setTitle("메뉴", for: .normal)
        menuButton.backgroundColor = .white
        menuButton.tintColor = UIColor(red: 131/255.0, green: 51/255.0, blue: 230/255.0, alpha: 1)
        
        storeInfoButton.setTitle("가게 정보", for: .normal)
        storeInfoButton.backgroundColor = .white
        storeInfoButton.tintColor = UIColor(red: 131/255.0, green: 51/255.0, blue: 230/255.0, alpha: 1)
        
        menuButtonClick()
    }
    func clickEventDelegate(item: UITabBarItem) {
        switch(item.tag) {
            case 0:
                self.performSegue(withIdentifier: "BottomTabBarController", sender: 0)
            case 1:
                self.performSegue(withIdentifier: "BottomTabBarController", sender: 1)
            case 2:
                self.performSegue(withIdentifier: "BottomTabBarController", sender: 2)
            case 3:
                self.performSegue(withIdentifier: "BottomTabBarController", sender: 3)
            case 4:
                self.performSegue(withIdentifier: "BottomTabBarController", sender: 4)
            default :
                print("none click")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let isBottomView = segue.destination as? BottomTabBarController else { return }
        let index = sender as! Int
        isBottomView.indexValue = index
    }
    func settingBottomBar() {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        setBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        setBottomTabBar.eventDelegate = self
    }
    @IBAction func backbutton() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func menuButtonClick() {
        menuButton.tintColor = UIColor(red: 131/255.0, green: 51/255.0, blue: 230/255.0, alpha: 1)
        storeInfoButton.tintColor = UIColor(red: 196/255.0, green: 196/255.0, blue: 196/255.0, alpha: 1)
        UIView.animate(withDuration: 0.7) {
            self.tabIndecator.transform = CGAffineTransform(translationX: 0.0, y: self.tabIndecator.bounds.height - 2)
        }
        
        let storyboard = UIStoryboard(name: "AboutStore", bundle: nil)
        guard let VC = storyboard.instantiateViewController(withIdentifier: "StoreMenuController") as? StoreMenuController else {return}
        
        VC.store_id = self.store_id
        self.addChild(VC)
        FirstPage.addSubview((VC.view)!)
        VC.view.frame = FirstPage.bounds
        VC.didMove(toParent: self)
        print("menuButtonClick")
    }
    @IBAction func storeInfoButtonClick() {
        storeInfoButton.tintColor = UIColor(red: 131/255.0, green: 51/255.0, blue: 230/255.0, alpha: 1)
        menuButton.tintColor = UIColor(red: 196/255.0, green: 196/255.0, blue: 196/255.0, alpha: 1)
        UIView.animate(withDuration: 0.7) {
            self.tabIndecator.transform = CGAffineTransform(translationX: self.storeInfoButton.bounds.width, y: self.tabIndecator.bounds.height - 2)
        }
        let storyboard = UIStoryboard(name: "AboutStore", bundle: nil)
        guard let VC = storyboard.instantiateViewController(withIdentifier: "StoreInfoController") as? StoreInfoController else {return}
        VC.StoreInfo = self.StoreInfo
        self.addChild(VC)
        FirstPage.addSubview((VC.view)!)
        VC.view.frame = FirstPage.bounds
        VC.didMove(toParent: self)
        print("storeInfoButtonClick")
    }
    @IBAction func setFavoriteImageButton() {
        UserDefaults.standard.set(self.isFlag, forKey: "isFlag")
        if (self.isFlag == 1) { // 즐겨찾기가 되어있는 경우에서 삭제
            self.performSegue(withIdentifier: "FavoriteDialog", sender: nil)
            self.delFavorite()
        }
        else { // 즐겨찾기가 안되있는 경우에서 추가
            self.performSegue(withIdentifier: "FavoriteDialog", sender: nil)
            self.addFavorite()
        }
    }
    func addFavorite() {
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        let param = ["phone":"\(phone)", "store_id":"\(self.store_id)"]
        netWork.post(method: .post, param: param, url: urlMaker.addFavoriteURL) {
            json in
            print("addFavorite: ", json)
            if json["result"].boolValue {
                self.isFavoriteBtn.setImage(UIImage(named: "heart_fill"), for: .normal)
                self.isFlag = 1
            }
            else {
                self.isFavoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
            }
        }
    }
    func delFavorite() {
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        let param = ["phone":"\(phone)", "store_id":"\(self.store_id)"]
        netWork.post(method: .post, param: param, url: urlMaker.delFavoriteURL) {
            json in
            print("delFavorite: ", json)
            if json["result"].boolValue {
                self.isFavoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
                self.isFlag = 0
            }
            else {
                self.isFavoriteBtn.setImage(UIImage(named: "heart_fill"), for: .normal)
            }
        }
    }
    func getStoreInfo() {
        netWork.get(method: .get, url: urlMaker.storeIntroductionURL + self.store_id) {
            json in
            print("storeInfo : ",json)
            if (json["result"].boolValue) {
                self.StoreInfo.store_id = json["store_id"].intValue
                self.StoreInfo.store_opentime = json["store_opentime"].stringValue
                self.StoreInfo.store_info = json["store_info"].stringValue
                self.StoreInfo.store_latitude = json["store_latitude"].doubleValue
                self.StoreInfo.store_closetime = json["store_closetime"].stringValue
                self.StoreInfo.store_daysoff = json["store_daysoff"].stringValue
                self.StoreInfo.message = json["message"].stringValue
                self.StoreInfo.store_phone = json["store_phone"].stringValue
                self.StoreInfo.store_longitude = json["store_longitude"].doubleValue
                self.StoreInfo.store_name = json["store_name"].stringValue
                self.StoreInfo.store_location = json["store_location"].stringValue
                self.StoreInfo.type_code = json["type_code"].stringValue
                self.StoreInfo.store_image = json["store_image"].stringValue
                self.StoreInfo.is_open = json["is_open"].stringValue
                
                self.storeTitle.text = self.StoreInfo.store_name
                UserDefaults.standard.set(self.StoreInfo.store_name, forKey: "currentStoreName")
                UserDefaults.standard.set(self.StoreInfo.store_id, forKey: "currentStoreId")
            } else {
                print("make request fail")
            }
        }
    }
    func isFavoriteStore() {
        print("in the favoriteStore")
        let phone = UserDefaults.standard.value(forKey: "user_phone") as! String
        let param = ["phone":"\(phone)", "store_id":"\(self.store_id)"]
        print("param : " , param)
        netWork.post(method: .post, param: param, url: urlMaker.isFavoriteURL) {
            json in
            print("isFavorite : ",json)
            if json["result"].boolValue {
                self.isFavoriteBtn.setImage(UIImage(named: "heart_fill"), for: .normal)
                self.isFlag = 1
            }
            else {
                self.isFavoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
                self.isFlag = 0
            }
        }
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
