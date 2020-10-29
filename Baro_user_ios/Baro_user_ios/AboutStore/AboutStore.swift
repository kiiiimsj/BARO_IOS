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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var storeInfoButton: UIButton!
    @IBOutlet weak var tabIndecator: UIView!
    
    public var store_id  = ""
    private let netWork = CallRequest()
    private let urlMaker = NetWorkURL()
    private var menus = [Menu]()
    private var StoreInfo = StoreInfoModel()
    private var storeInfoManager = StoreInfoController()
    private var storeMenuManager = StoreMenuController()
    private var contollers = [UIViewController]()
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabBarItem()
        UIView.animate(withDuration: 0.0) {
            self.tabIndecator.transform = CGAffineTransform(rotationAngle: 0.0)
        }
        print("from : ",tabIndecator.transform)
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
        
        self.addChild(VC)
        FirstPage.addSubview((VC.view)!)
        VC.view.frame = FirstPage.bounds
        VC.didMove(toParent: self)
        print("storeInfoButtonClick")
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
