//
//  BottomTapBarControllerViewController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit
//분기문에 사용할 실제 컨트롤러 아이덴티피어
let mainPageControllerIdentifier = "MainPageController"
let storeListControllerIdentifier = "StoreListPageController"
let orderStatusControllerIdentifier = "OrderStatusController"
let orderHistoryControllerIdentifier = "OrderHistoryController"
let myPageControllerIdentifier = "MyPageController"

class BottomTabBarController: UIViewController {
    //탑뷰 엘리먼트
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var topBarBackBtn: UIButton!
    @IBOutlet weak var topBarViewControllerTitle: UILabel!
    
    //컨텐트뷰 엘리먼트
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ContentViewScrollView: UIScrollView!
    
    //바텀뷰 엘리먼트
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var bottomTabBar: UITabBar!
    
    //접근가능 스토리보드
    let mainPageStoryBoard = UIStoryboard(name: "MainPage", bundle: nil)
    let storeListStoryBoard = UIStoryboard(name: "StoreListPage", bundle: nil)
    let orderStatusStoryBoard = UIStoryboard(name: "OrderStatus", bundle: nil)
    let orderHistoryStoryBoard = UIStoryboard(name: "OrderHistory", bundle: nil)
    let myPageStoryBoard = UIStoryboard(name: "MyPage", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomTabBar.delegate = self
    }
    //내부 뷰 컨트롤러 분기문
    func changeViewController(getController : String, getStoryBoard : UIStoryboard) {
        let controller = getStoryBoard.instantiateViewController(identifier: getController)
        switch(getController) {
            case "MainPageController":
                changeContentView(controller: controller as! MainPageController)
                deleteTopView()
            case "StoreListPageController":
                changeContentView(controller: controller as! StoreListPageController)
            case "OrderStatusController":
                changeContentView(controller: controller as! OrderStatusController)
            case "OrderHistoryController":
                changeContentView(controller: controller as! OrderHistoryController)
            case "MyPageController":
                changeContentView(controller: controller as! MyPageController)
            default :
                print("error_delegate")
        }
    }
    //내부 뷰 추가
    func changeContentView(controller : UIViewController) {
        self.addChild(controller)
        ContentView.addSubview(controller.view)
        controller.view.frame.size = ContentView.frame.size
        controller.didMove(toParent: self)
    }
    
    //탑뷰 지우기
    func deleteTopView() {
        TopView.isHidden = true
        
        //컨텐트뷰 사이지를 다시 조정
        let topViewSize = TopView.frame.size
        let contentViewSize = ContentView.frame.size
        ContentView.frame.size = CGSize(width: view.frame.width, height: (topViewSize.height + contentViewSize.height))
        ContentViewScrollView.topAnchor.constraint(equalTo: TopView.topAnchor).isActive = true
    }
}
extension BottomTabBarController : UITabBarDelegate {
    //탭바아이템 클릭에 따른 분기문
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("item tab : ", item.title)
        switch(item.title) {
        case "홈":
            self.changeViewController(getController: mainPageControllerIdentifier, getStoryBoard: mainPageStoryBoard)
        case "내 가게":
            self.changeViewController(getController: storeListControllerIdentifier, getStoryBoard: storeListStoryBoard)
        case "주문 현황":
            self.changeViewController(getController: orderStatusControllerIdentifier, getStoryBoard: orderStatusStoryBoard)
        case "주문 내역":
            self.changeViewController(getController: orderHistoryControllerIdentifier, getStoryBoard: orderHistoryStoryBoard)
        case "마이페이지":
            self.changeViewController(getController: myPageControllerIdentifier, getStoryBoard: myPageStoryBoard)
        default :
            print("click none")
        }
    }
}
