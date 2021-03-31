//
//  BottomTapBarControllerViewController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit
import NMapsMap
import FirebaseAuth

protocol TopViewElementDelegate : AnyObject {
    func favoriteBtnDelegate(controller : UIViewController)
    func refreshBtnDelegate(controller : UIViewController)
}

class BottomTabBarController: UIViewController {
    //탑뷰 엘리먼트
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var topBarBackBtn: UIButton!
    @IBOutlet weak var topBarViewControllerTitle: UILabel!
    @IBOutlet weak var topBarRefreshBtn: UIButton!
    @IBOutlet weak var topBarFavoriteBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    //내부 컨트롤러 클릭 인식용.
    weak var topViewDelegate : TopViewElementDelegate?
    //컨텐트뷰 엘리먼트
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ContentViewScrollView: UIScrollView!
    @IBOutlet weak var basketButton: UIButton!
    //바텀뷰 엘리먼트
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var bottomTabBar: UITabBar!
    //바텀뷰 텝 아이템
    @IBOutlet weak var MainPageTabBar: UITabBarItem!
    @IBOutlet weak var FavoriteTabBar: UITabBarItem!
    @IBOutlet weak var MyPageTabBar: UITabBarItem!
    @IBOutlet weak var OrderHistoryTabBar: UITabBarItem!
    @IBOutlet weak var OrderStatusTabBar: UITabBarItem!
// 서버통신
    public lazy var netWork = CallRequest()
    public lazy var urlMaker = NetWorkURL()
    //분기문에 사용할 실제 컨트롤러 아이덴티피어
    static var activityIndicator: UIActivityIndicatorView = { // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.baro_main_color// Start animation.
//        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    let mainPageControllerIdentifier = "MainPageController"
    let newMainPageControllerIdentifier = "NewMainPageController"
    let storeListControllerIdentifier = "StoreListPageController"
    let orderStatusControllerIdentifier = "OrderStatusController"
    let orderHistoryControllerIdentifier = "OrderHistoryController"
    let orderDetailControllerIdentifier = "OrderDetailsController"
    let myPageControllerIdentifier = "MyPageController"
    let aboutStoreControllerIdentifier = "AboutStore"
    let alertControllerIdentifier = "AlertController"
    let alertContentControllerIdentifier = "AlertContentController"
    let couponPageControllerIdentifier = "CouponPageController"
    let basketControllerIdentifier = "BasketController"
    let mapControllerIdentifier = "MapController"
    //접근가능 스토리보드
    let mainPageStoryBoard = UIStoryboard(name: "MainPage", bundle: nil)
    let newMainPageStoryBoard = UIStoryboard(name: "NewMainPage", bundle: nil)
    let storeListStoryBoard = UIStoryboard(name: "StoreListPage", bundle: nil)
    let orderStatusStoryBoard = UIStoryboard(name: "OrderStatus", bundle: nil)
    let orderHistoryStoryBoard = UIStoryboard(name: "OrderHistory", bundle: nil)
    let orderDetailStoryBoard = UIStoryboard(name: "OrderDetails", bundle: nil)
    let myPageStoryBoard = UIStoryboard(name: "MyPage", bundle: nil)
    let termOfUserStoryBoard = UIStoryboard(name: "Terms", bundle: nil)
    let aboutStoreStoryBoard = UIStoryboard(name: "AboutStore", bundle: nil)
    let alertStoryBoard = UIStoryboard(name: "Alert", bundle: nil)
    let couponPageStoryBoard = UIStoryboard(name: "Coupon", bundle: nil)
    let basketStoryBoard = UIStoryboard(name: "Basket", bundle: nil)
    let mapPageStoryBoard = UIStoryboard(name: "Map", bundle: nil)
    //화면 이동 할때 필요한 요소.
    var controllerStoryboard = UIStoryboard()
    var controllerIdentifier : String = ""
    var controllerSender : Any?
    //내부이동 (바텀 탭바를 이용한 화면 이동)이 아닌경우 이 값은 true로 해주어야 이동가능.
    var moveFromOutSide : Bool = false
    //바텀탭 로딩후 선택되어지는 탭바아이템
    var selectedTabBarItem : Int = 0
    //장바구니 관련 요소
    var basket : Any?
    var basketOrders = [Order]()
    //aboutstore 관련 요소
    var currentStoreName : String = ""
    //listStore 관련 요소
    var beforeKind : String = "0"
    
    //내부 뷰 사이즈 관련 요소
    var saveTopViewSize = CGSize()
    var saveContentViewSize = CGSize()
    var saveBottomViewSize = CGSize()
    @IBOutlet weak var timeViewRestoreConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTopDeleteConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTopRestoreConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveContentViewSize = CGSize(width: view.frame.width, height: 700.0)
        saveTopViewSize = CGSize(width: view.frame.width, height: 69.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let storeName = UserDefaults.standard.value(forKey: "currentStoreName") as? String {
            currentStoreName = storeName
        }
        //aboutstore나 storelist 접근 시 viewload에서 controller 변경 구문
        if(moveFromOutSide) {
            changeViewController(getController: controllerIdentifier, getStoryBoard: controllerStoryboard, sender: controllerSender)
            moveFromOutSide = false
        }
        //basket userdefault 유무 버튼 비활성화/활성화 구문
        isBasketExist()
        bottomTabBar.delegate = self
    }
    
    func isBasketExist() {
        basket = UserDefaults.standard.value(forKey: "basket")
        if(basket != nil) {
            if(basket as! String == "") {
                basketButton.isHidden = true
                return
            }
            if(controllerIdentifier == "MainPageController" || controllerIdentifier == "StoreListPageController" || controllerIdentifier == "NewMainPageController"
            || controllerIdentifier == "OrderStatusController" || controllerIdentifier == "OrderHistoryController" || controllerIdentifier == "MyPageContrllor" || controllerIdentifier == "AboutStore") {
                basketButton.isHidden = false
            } else {
                basketButton.isHidden = true
                return
            }
            getOrders()
            
            if(basketOrders.count == 0) {
                basketButton.isHidden = true
                return
            }
            basketBadge()
        } else {
            basketButton.isHidden = true
        }
    }
    //장바구니 아이템 갯수를 가져오기 위한 json decoder function
    func getOrders() {
        let decoder = JSONDecoder()
        var jsonToOrder = [Order]()
        if let getData = basket as? String {
            let data = getData.data(using: .utf8)!
            jsonToOrder = try! decoder.decode([Order].self, from: data)
        }
        basketOrders = jsonToOrder
    }
    //장바구니 아이템 개수 표시 label 설정
    func basketBadge(){
        //장바구니의 개수가 0이라면 return
        var count = 0
        if(basketOrders.count == 0) {
            return
        }
        basketButton.isHidden = false
        basketButton.layer.borderWidth = 2
        basketButton.layer.cornerRadius = basketButton.bounds.size.height / 2
        basketButton.layer.borderColor = UIColor.clear.cgColor
        
                
        let label = UILabel(frame: CGRect(x: 21, y: 9, width: 12, height: 12))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 9)
        label.textColor = UIColor.baro_main_color
        label.backgroundColor = .white
        for order in basketOrders {
            count += order.menu_count
        }
        label.text = "\(count)"
        
        basketButton.addSubview(label)
    }
    //내부 뷰 컨트롤러 분기문
    func changeViewController(getController : String, getStoryBoard : UIStoryboard, sender : Any?) {
        let controller = getStoryBoard.instantiateViewController(identifier: getController)
        if (ContentView.subviews.count != 0) {
            for view in ContentView.subviews {
                if let viewTitle = view.accessibilityIdentifier {
                    if(viewTitle == controller.restorationIdentifier) {
                        //storeListPage 오류 분기문
                        if (viewTitle == "StoreListPageController" && sender as! String != beforeKind) {
                            //mainpage -> storeList 에서 favoriteStore로 이동 시
                            //둘 다 같은 StoreListPageController 이므로 favoriteStore 페이지는 로드 되지 않는다.
                            //beforeKind로 기존의 페이지가 StoreList인지 favoriteStoreList 인지 확인 한다.
                            
                            //만약 같은 다른 페이지라면 이전의 storeList를 지우고 favoriteStoreList로 이동
                            view.removeFromSuperview()
                            continue
                        }
                        return
                    }
                }
                view.removeFromSuperview()
            }
        }
        if(TopView.isHidden) {
            restoreTopView()
        }
        switch(getController) {
            case mainPageControllerIdentifier:
                self.deleteTopView()
                self.changeContentView(controller: controller as! MainPageController, sender: nil)
            case newMainPageControllerIdentifier:
                self.deleteTopView()
                self.changeContentView(controller: controller as! NewMainPageController, sender: nil)
            case storeListControllerIdentifier:
                self.changeContentView(controller: controller as! StoreListPageController, sender: sender)
            case orderStatusControllerIdentifier:
                self.changeContentView(controller: controller as! OrderStatusController, sender: nil)
            case orderHistoryControllerIdentifier:
                self.changeContentView(controller: controller as! OrderHistoryController, sender: nil)
            case alertControllerIdentifier:
                self.changeContentView(controller: controller as! AlertController, sender: sender)
                self.deleteBottomTabBar()
                swipeRecognizer()
            case alertContentControllerIdentifier:
                
                self.changeContentView(controller: controller as! AlertContentController, sender: sender)
                self.deleteBottomTabBar()
                swipeRecognizer()
            case orderDetailControllerIdentifier:
                
                self.changeContentView(controller: controller as! OrderDetailsController, sender: sender)
                self.deleteBottomTabBar()
            case myPageControllerIdentifier:
                self.changeContentView(controller: controller as! MyPageController, sender: nil)
            case aboutStoreControllerIdentifier:
                self.changeContentView(controller: controller as! AboutStore, sender: sender)
                swipeRecognizer()
            case couponPageControllerIdentifier:
                
                self.changeContentView(controller: controller as! CouponPageController, sender: nil)
                self.deleteBottomTabBar()
                swipeRecognizer()
            case basketControllerIdentifier:
                
                self.changeContentView(controller: controller as! BasketController, sender: sender)
                self.deleteBottomTabBar()
                swipeRecognizer()
            case mapControllerIdentifier:
                
                self.changeContentView(controller: controller as! MapController, sender: sender)
                self.deleteBottomTabBar()
                swipeRecognizer()
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
        bottomTabBarItemActive(controller: getController)
        self.addChild(getController)
        getController.view.frame.size = ContentView.frame.size
        //같은 컨트롤러에 다시 접근하는 여부를 알기 위해 restorationidentifier를 넣어주는 구문
        getController.view.accessibilityIdentifier = getController.restorationIdentifier
        //controlleridentifier와 동일하다.
        //해당 구문은 tabbaritem으로 전환되는 viewcontroller에 해당된다.
        ContentView.addSubview(getController.view)
        getController.didMove(toParent: self)
        isBasketExist()
    }
    //탑뷰 추가
    func restoreTopView() {
        TopView.isHidden = false
        contentViewTopDeleteConstraint.isActive = false
        contentViewTopRestoreConstraint.isActive = true
//        timeViewRestoreConstraint.isActive = true
    }
    //탑뷰 지우기
    func deleteTopView() {
        TopView.isHidden = true
        contentViewTopDeleteConstraint.isActive = true
        contentViewTopRestoreConstraint.isActive = false
    }
    func deleteBottomTabBar() {
        ContentView.frame.size = CGSize(width: view.frame.width, height: (saveContentViewSize.height + saveBottomViewSize.height))
        ContentViewScrollView.frame.size = CGSize(width: view.frame.width, height: (saveContentViewSize.height + saveBottomViewSize.height))
        ContentViewScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        BottomView.isHidden = true
        
    }
    //sender가 존재하는 컨트롤러 처리
    func senderHandler(controller : UIViewController, sender : Any) -> UIViewController{
        var finallController = UIViewController()
        if let title = controller.title {
            switch(title) {
            case orderDetailControllerIdentifier:
                let VCsender = controller as! OrderDetailsController
                
                let param = sender as! [String:Any]
                VCsender.menu_id = param["menuId"] as! String
                let decoder = JSONDecoder()
                
                if let getData = param["menu"] as? String {
                    let data = getData.data(using: .utf8)!
                    VCsender.menu  = try! decoder.decode(Menu.self, from: data)
                }
                VCsender.storeId = param["storeId"] as! Int
                VCsender.discount_rate = param["discount_rate"] as! Int
                finallController = VCsender
            case aboutStoreControllerIdentifier:
                let VCsender = controller as! AboutStore
                let data = sender as! [String : Any]
                VCsender.store_id = data["id"]! as! Int
                VCsender.discount_rate = data["discount_rate"]! as! Int

                finallController = VCsender
            case storeListControllerIdentifier:
                let VCsender = controller as! StoreListPageController
                if sender is [String:Any]{
                    let param = sender as! [String : Any]
                    VCsender.kind = 3
                    VCsender.searchWord = param["search"] as! String
                    finallController = VCsender
                    swipeRecognizer()
                    return finallController
                }
                VCsender.typeCode = (sender as? String)!
                if(VCsender.typeCode == "2") {
                    //즐겨찾기로 넘어갈때 저장.
                    self.beforeKind = "2"
                    VCsender.kind = 2
                }
                else {
                    VCsender.kind = 1
                    swipeRecognizer()
                }
                finallController = VCsender
            case alertControllerIdentifier:
                let VCsender = controller as! AlertController
                VCsender.userPhone = sender as! String
                finallController = VCsender
            case alertContentControllerIdentifier:
                let VCsender = controller as! AlertContentController
                VCsender.Alert = sender as! AlertModel
                finallController = VCsender
            case basketControllerIdentifier:
                let VCsender = controller as! BasketController
                let data = sender as! [String : Any]
                VCsender.orders = data["jsonToOrder"] as! [Order]
                VCsender.discount_rate = data["discount_rate"] as! Int
                finallController = VCsender
            case mapControllerIdentifier:
                let VCsender = controller as! MapController
                VCsender.location = sender as? CLLocation
                finallController = VCsender
            default:
                print("error")
            }
        }
        return finallController
    }
    
    //바텀 탭바 아이템 설정
    func bottomTabBarItemActive(controller : UIViewController) {
        if let title = controller.title {
            switch (title) {
            case mainPageControllerIdentifier:
                bottomTabBar.selectedItem = self.MainPageTabBar
            case newMainPageControllerIdentifier:
                bottomTabBar.selectedItem = self.MainPageTabBar
            case storeListControllerIdentifier:
                let controllerData = controller as! StoreListPageController
                if(controllerData.typeCode == "2") {
                    self.bottomTabBar.selectedItem = self.FavoriteTabBar
                }
            case orderStatusControllerIdentifier:
                self.bottomTabBar.selectedItem = self.OrderStatusTabBar
            case orderHistoryControllerIdentifier:
                self.bottomTabBar.selectedItem = self.OrderHistoryTabBar
            case myPageControllerIdentifier:
                self.bottomTabBar.selectedItem = self.MyPageTabBar
            default:
                print("default")
            }
        }
        
    }
    //탑바 타이틀 설정
    func topBarHandler(controller : UIViewController) {
        basketButton.isHidden = true
        topBarBackBtn.isHidden = true
        timeView.isHidden = true
        topBarFavoriteBtn.isHidden = true
        topBarRefreshBtn.isHidden = true
        topBarViewControllerTitle.isHidden = false
        if let title = controller.title {
            switch(title) {
                case mainPageControllerIdentifier:
                    topBarViewControllerTitle.text = "main"
                case newMainPageControllerIdentifier:
                    topBarViewControllerTitle.text = "main"
                case storeListControllerIdentifier:
                    let controllerData = controller as! StoreListPageController
                    if(controllerData.typeCode == "2") {
                        topBarViewControllerTitle.text = "찜한 가게"
                        showTime(controller: controllerData)
                        maxmizeTopView()
                    }
                    else if(controllerData.kind == 3) {
                        topBarViewControllerTitle.text = "검색 가게"
                        topBarBackBtn.isHidden = false
                        showTime(controller: controllerData)
                        maxmizeTopView()
                    }
                    else {
                        topBarBackBtn.isHidden = false
                        minimizeTopView()
                    }
                    
                    if (controllerData.typeCode == "CAFE") {
                        topBarViewControllerTitle.text = "카페"
                        minimizeTopView()
                    }
                    if (controllerData.typeCode == "DESSERT") {
                        topBarViewControllerTitle.text = "디저트"
                        minimizeTopView()
                    }
                    if (controllerData.typeCode == "JAPANESE") {
                        topBarViewControllerTitle.text = "일식"
                        minimizeTopView()
                    }
                    if (controllerData.typeCode == "KOREAN") {
                        topBarViewControllerTitle.text = "한식"
                        minimizeTopView()
                    }
                    
                case orderDetailControllerIdentifier:
                    topBarViewControllerTitle.isHidden = false
                    topBarBackBtn.isHidden = false
                    let tempStoreName = UserDefaults.standard.value(forKey: "tempStoreName")
                    if tempStoreName != nil {
                        topBarViewControllerTitle.text = "\(tempStoreName as! String)"
                    }else{
                        topBarViewControllerTitle.text = "\(currentStoreName)"
                    }
                    let controllerData = controller as! OrderDetailsController
                    showTime(controller: controllerData)
                    break
                case orderStatusControllerIdentifier:
                    topBarViewControllerTitle.text = "주문 현황"
                    topBarRefreshBtn.isHidden = false
                    let controllerData = controller as! OrderStatusController
                    controllerData.bottomTabBarInfo = self
                    minimizeTopView()
                case orderHistoryControllerIdentifier:
                    topBarViewControllerTitle.text = "주문 내역"
                    minimizeTopView()
                case myPageControllerIdentifier:
                    topBarViewControllerTitle.text = "마이페이지"
                    minimizeTopView()
                    
                case alertControllerIdentifier:
                    topBarViewControllerTitle.text = "알 림"
                    topBarBackBtn.isHidden = false
                    minimizeTopView()
                    
                case alertContentControllerIdentifier:
                    topBarViewControllerTitle.isHidden = true
                    topBarBackBtn.isHidden = false
                    minimizeTopView()
                    
                case aboutStoreControllerIdentifier:
                    topBarFavoriteBtn.isHidden = false
                    topBarBackBtn.isHidden = false
                    let tempStoreName = UserDefaults.standard.value(forKey: "tempStoreName")
                    if tempStoreName != nil {
                        topBarViewControllerTitle.text = "\(tempStoreName as! String)"
                    }else{
                        topBarViewControllerTitle.text = "\(currentStoreName)"
                    }
                    let controllerData = controller as! AboutStore
                    controllerData.bottomTabBarInfo = self
                    showTime(controller: controllerData)
                    break
                case couponPageControllerIdentifier:
                    topBarViewControllerTitle.text = "내 쿠폰 리스트"
                    topBarBackBtn.isHidden = false
                    minimizeTopView()
                case basketControllerIdentifier:
                    topBarViewControllerTitle.text = "장바구니"
                    topBarBackBtn.isHidden = false
                    let controllerData = controller as! BasketController
                    showTime(controller: controllerData)
                    break
                case mapControllerIdentifier:
                    topBarViewControllerTitle.text = "내 주변 가게"
                    topBarBackBtn.isHidden = false
                    minimizeTopView()
                default :
                    print("error_delegate")
            }
        }
    }
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
        }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        var viewTranslation = CGPoint(x: 0, y: 0)
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: nil)
        }
    }
    //뒤로가기 버튼
    @IBAction func clickTopBarBackBtn() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickFavoriteBtn() {
        topViewDelegate?.favoriteBtnDelegate(controller: self)
    }
    @IBAction func clickRefreshBtn() {
        topViewDelegate?.refreshBtnDelegate(controller: self)
        UIView.animate(withDuration: 0.7) {
            self.topBarRefreshBtn?.transform = (self.topBarRefreshBtn?.transform.rotated(by: CGFloat.pi))!
            self.topBarRefreshBtn?.transform = (self.topBarRefreshBtn?.transform.rotated(by: CGFloat.pi))!
        }
    }
    @IBAction func clickBasketBtn() {
        self.getOrders()
        let basketControllerWithTopView = self.storyboard?.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        basketControllerWithTopView.modalPresentationStyle = .fullScreen
        basketControllerWithTopView.modalTransitionStyle = .crossDissolve
        basketControllerWithTopView.controllerStoryboard = self.basketStoryBoard
        basketControllerWithTopView.controllerIdentifier = self.basketControllerIdentifier
        let store_id = UserDefaults.standard.value(forKey: "currentStoreId")
        if store_id == nil {
            return
        } else if store_id as? String == ""{
            return
        }else{
            netWork.get(method: .get, url: urlMaker.reloadStoreDiscount + String(store_id as! Int)) {json in
                if json["result"].boolValue {
                    let discount_rate = json["discount_rate"].intValue
                    let data = ["jsonToOrder" : self.basketOrders,"discount_rate" : discount_rate] as [String : Any]
                    basketControllerWithTopView.controllerSender = data
                    basketControllerWithTopView.moveFromOutSide = true
                    self.present(basketControllerWithTopView, animated: true)
                }else{
                    return
                }
            }
        }
       
    }
    public static func stopLoading(){
        activityIndicator.stopAnimating()
    }
}
extension BottomTabBarController : UITabBarDelegate {
    //탭바아이템 클릭에 따른 분기문
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        timeView.isHidden = true
        switch(item.title) {
        case "홈":
//            changeViewController(getController: mainPageControllerIdentifier, getStoryBoard: mainPageStoryBoard, sender: nil)
            changeViewController(getController: newMainPageControllerIdentifier, getStoryBoard: newMainPageStoryBoard, sender: nil)
        case "찜한 가게":
            guard UserDefaults.standard.value(forKey: "user_phone") != nil else{
                let vc = UIStoryboard.init(name: "BottomTabBar", bundle: nil).instantiateViewController(identifier: "GoLoginController")
                checkController()
                self.present(vc, animated: true, completion: nil)
                return
            }
            changeViewController(getController: storeListControllerIdentifier, getStoryBoard: storeListStoryBoard, sender: "2")
        case "주문 현황":
            guard UserDefaults.standard.value(forKey: "user_phone") != nil else{
                let vc = UIStoryboard.init(name: "BottomTabBar", bundle: nil).instantiateViewController(identifier: "GoLoginController")
                checkController()
                self.present(vc, animated: true, completion: nil)
                return
            }
            changeViewController(getController: orderStatusControllerIdentifier, getStoryBoard: orderStatusStoryBoard, sender: nil)
        case "주문 내역":
            guard UserDefaults.standard.value(forKey: "user_phone") != nil else{
                let vc = UIStoryboard.init(name: "BottomTabBar", bundle: nil).instantiateViewController(identifier: "GoLoginController")
                checkController()
                self.present(vc, animated: true, completion: nil)
                return
            }
            changeViewController(getController: orderHistoryControllerIdentifier, getStoryBoard: orderHistoryStoryBoard, sender: nil)
        case "마이페이지":
            guard UserDefaults.standard.value(forKey: "user_phone") != nil else{
                let vc = UIStoryboard.init(name: "BottomTabBar", bundle: nil).instantiateViewController(identifier: "GoLoginController")
                checkController()
                self.present(vc, animated: true, completion: nil)
                return
            }
            changeViewController(getController: myPageControllerIdentifier, getStoryBoard: myPageStoryBoard, sender: nil)
        default :
            print("click none")
        }
    }
    func checkController() {
        if (ContentView.subviews.count != 0) {
            for view in ContentView.subviews {
                if(view.accessibilityIdentifier == "StoreListPageController" ||
                    view.accessibilityIdentifier == "AboutStore") {
                    self.bottomTabBar.selectedItem = nil
                }else {
                    self.bottomTabBar.selectedItem = self.MainPageTabBar
                }
            }
        }
    }
}
extension BottomTabBarController {
    func minimizeTopView() -> Void {
//        let issueLabelsHeightConstraint = self.TopView.heightAnchor.constraint(
//            equalToConstant: CGFloat(50))
//        issueLabelsHeightConstraint.isActive = true
        topViewHeight.constant = 50
    }
    func maxmizeTopView() -> Void {
//        let issueLabelsHeightConstraint = self.TopView.heightAnchor.constraint(
//            equalToConstant: CGFloat(50))
//        issueLabelsHeightConstraint.isActive = true
        topViewHeight.constant = 100
    }
    func showTime(controller : UIViewController){ // 시간탭 보여주는 부분
        timeView.isHidden = false
        timeLabel.text = CustomTimer.getTime()
        self.view.addSubview(BottomTabBarController.activityIndicator)
        BottomTabBarController.activityIndicator.center = self.view.center
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updatetime(sender:)), userInfo: controller, repeats: true)
    }
    @objc func updatetime(sender : Timer) {
        let time = CustomTimer.getTime()
        timeLabel.text = time
        if time == CustomTimer.RELOAD_TIME {
            BottomTabBarController.activityIndicator.startAnimating()
            let vc = sender.userInfo as! UIViewController
            switch vc.title {
            case aboutStoreControllerIdentifier:
                let rvc = vc as! AboutStore
                rvc.reloadAboutStore()
            case orderDetailControllerIdentifier :
                let rvc = vc as! OrderDetailsController
                rvc.reloadOrderDetail()
            case basketControllerIdentifier :
                let rvc = vc as! BasketController
                rvc.reloadBasket()
            case storeListControllerIdentifier :
                let rvc = vc as! StoreListPageController
                rvc.reloadStoreList()
            default: break
                
            }
        }else {
            return
        }
    }
}

