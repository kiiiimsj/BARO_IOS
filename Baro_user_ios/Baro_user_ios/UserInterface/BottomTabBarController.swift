//
//  BottomTapBarControllerViewController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit

protocol TopViewElementDelegate : AnyObject {
    func backBtnDelegate()
    func favoriteBtnDelegate(controller : UIViewController)
}
class BottomTabBarController: UIViewController {
    //탑뷰 엘리먼트
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var topBarBackBtn: UIButton!
    @IBOutlet weak var topBarViewControllerTitle: UILabel!
    @IBOutlet weak var topBarFavoriteBtn: UIButton!
    //내부 컨트롤러 클릭 인식용.
    weak var topViewDelegate : TopViewElementDelegate?
    //컨텐트뷰 엘리먼트
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ContentViewScrollView: UIScrollView!
    //바텀뷰 엘리먼트
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var bottomTabBar: UITabBar!
    //분기문에 사용할 실제 컨트롤러 아이덴티피어
    let mainPageControllerIdentifier = "MainPageController"
    let storeListControllerIdentifier = "StoreListPageController"
    let orderStatusControllerIdentifier = "OrderStatusController"
    let orderHistoryControllerIdentifier = "OrderHistoryController"
    let myPageControllerIdentifier = "MyPageController"
    let aboutStoreControllerIdentifier = "AboutStore"
    
    //접근가능 스토리보드
    let mainPageStoryBoard = UIStoryboard(name: "MainPage", bundle: nil)
    let storeListStoryBoard = UIStoryboard(name: "StoreListPage", bundle: nil)
    let orderStatusStoryBoard = UIStoryboard(name: "OrderStatus", bundle: nil)
    let orderHistoryStoryBoard = UIStoryboard(name: "OrderHistory", bundle: nil)
    let myPageStoryBoard = UIStoryboard(name: "MyPage", bundle: nil)
    let aboutStoreStoryBoard = UIStoryboard(name: "AboutStore", bundle: nil)
    
    //화면 이동 할때 필요한 요소.
    var controllerStoryboard = UIStoryboard()
    var controllerIdentifier : String = ""
    var controllerSender : Any = ""
    var moveFromOutSide : Bool = false
    
    //바텀탭 로딩후 선택되어지는 탭바아이템
    var selectedTabBarItem : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        topBarFavoriteBtn.isHidden = true
        if(moveFromOutSide) {
            changeViewController(getController: controllerIdentifier, getStoryBoard: controllerStoryboard, sender: controllerSender)
        }
        bottomTabBar.delegate = self
    }
    
    //내부 뷰 컨트롤러 분기문
    func changeViewController(getController : String, getStoryBoard : UIStoryboard, sender : Any?) {
        self.viewDidLoad()
        let controller = getStoryBoard.instantiateViewController(identifier: getController)
        switch(getController) {
            case mainPageControllerIdentifier:
                self.changeContentView(controller: controller as! MainPageController, sender: nil)
                self.deleteTopView()
            case storeListControllerIdentifier:
                self.changeContentView(controller: controller as! StoreListPageController, sender: sender)
                self.restoreTopView()
            case orderStatusControllerIdentifier:
                self.changeContentView(controller: controller as! OrderStatusController, sender: nil)
                self.restoreTopView()
            case orderHistoryControllerIdentifier:
                self.changeContentView(controller: controller as! OrderHistoryController, sender: nil)
                self.restoreTopView()
            case myPageControllerIdentifier:
                self.changeContentView(controller: controller as! MyPageController, sender: nil)
                self.restoreTopView()
            case aboutStoreControllerIdentifier:
                self.changeContentView(controller: controller as! AboutStore, sender: sender)
                topBarFavoriteBtn.isHidden = false
                //self.restoreTopView()
            default :
                print("error_delegate")
        }
    }
    //내부 뷰 추가
    func changeContentView(controller : UIViewController, sender : Any?) {
        //sender가 있는지 확인
        var getController = controller
        if let senderNotNil = sender {
            getController = self.senderHandler(controller: controller, sender: senderNotNil)
        }
        topBarHandler(controller: getController)
        self.addChild(getController)
        ContentView.addSubview(getController.view)
        getController.view.frame.size = ContentView.frame.size
        getController.didMove(toParent: self)
    }
    //탑뷰 추가
    func restoreTopView() {
        TopView.isHidden = false
        let topViewSize = TopView.frame.size
        let contentViewSize = ContentView.frame.size
        ContentView.frame.size = CGSize(width: view.frame.width, height: (contentViewSize.height - topViewSize.height))
        ContentViewScrollView.topAnchor.constraint(equalTo: TopView.bottomAnchor).isActive = true
        ContentView.topAnchor.constraint(equalTo: ContentViewScrollView.topAnchor).isActive = true
    }
    //탑뷰 지우기
    func deleteTopView() {
        TopView.isHidden = true
        //컨텐트뷰 사이지를 다시 조정
        let topViewSize = TopView.frame.size
        let contentViewSize = ContentView.frame.size
        ContentView.frame.size = CGSize(width: view.frame.width, height: (topViewSize.height + contentViewSize.height))
        ContentViewScrollView.topAnchor.constraint(equalTo: TopView.topAnchor).isActive = true
        ContentView.topAnchor.constraint(equalTo: ContentViewScrollView.topAnchor).isActive = true
    }
    //sender가 존재하는 컨트롤러 처리
    func senderHandler(controller : UIViewController, sender : Any) -> UIViewController{
        var finallController = UIViewController()
        if let title = controller.title {
            switch(title) {
            case aboutStoreControllerIdentifier:
                let VCsender = controller as! AboutStore
                VCsender.store_id = sender as! String
                finallController = VCsender
            case storeListControllerIdentifier:
                let VCsender = controller as! StoreListPageController
                VCsender.typeCode = sender as! String
                VCsender.kind = 1
                finallController = VCsender
            default:
                print("error")
            }
        }
        return finallController
    }
    //탑바 타이틀 설정
    func topBarHandler(controller : UIViewController) {
        if let title = controller.title {
            switch(title) {
                case storeListControllerIdentifier:
                    let controllerData = controller as! StoreListPageController
                    if (controllerData.typeCode == "CAFE") {
                        topBarViewControllerTitle.text = "카페"
                    }
                    if (controllerData.typeCode == "DESSERT") {
                        topBarViewControllerTitle.text = "디저트"
                    }
                    if (controllerData.typeCode == "JAPANESE") {
                        topBarViewControllerTitle.text = "일식"
                    }
                    if (controllerData.typeCode == "KOREAN") {
                        topBarViewControllerTitle.text = "한식"
                    }
                case orderStatusControllerIdentifier:
                    print("456")
                case orderHistoryControllerIdentifier:
                    print("789")
                case myPageControllerIdentifier:
                    print("112")
                case aboutStoreControllerIdentifier:
                    if let currentStoreName = UserDefaults.standard.value(forKey: "currentStoreName") as? String {
                        topBarViewControllerTitle.text = "\(currentStoreName)"
                    }
                    
                    let controllerData = controller as! AboutStore
                    controllerData.bottomTabBarInfo = self
                default :
                    print("error_delegate")
            }
        }
    }
    //뒤로가기 버튼
    @IBAction func clickTopBarBackBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickFavoriteBtn() {
        topViewDelegate?.favoriteBtnDelegate(controller: self)
    }
}
extension BottomTabBarController : UITabBarDelegate {
    //탭바아이템 클릭에 따른 분기문
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch(item.title) {
        case "홈":
            self.changeViewController(getController: self.mainPageControllerIdentifier, getStoryBoard: self.mainPageStoryBoard, sender: nil)
        case "내 가게":
            self.changeViewController(getController: self.storeListControllerIdentifier, getStoryBoard: self.storeListStoryBoard, sender: nil)
        case "주문 현황":
            self.changeViewController(getController: self.orderStatusControllerIdentifier, getStoryBoard: self.orderStatusStoryBoard, sender: nil)
        case "주문 내역":
            self.changeViewController(getController: self.orderHistoryControllerIdentifier, getStoryBoard: self.orderHistoryStoryBoard, sender: nil)
        case "마이페이지":
            self.changeViewController(getController: self.myPageControllerIdentifier, getStoryBoard: self.myPageStoryBoard, sender: nil)
        default :
            print("click none")
        }
    }
}
