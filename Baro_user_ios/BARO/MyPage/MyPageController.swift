//
//  MyPageController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/22.
//

import UIKit
import Kingfisher
import WebKit

class MyPageController : UIViewController {
    var networkModel = CallRequest()
    var networkURL = NetWorkURL()
    var userPhone = ""
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var OrderArea: UIView!
    @IBOutlet weak var couponArea: UIView!
    @IBOutlet weak var basketArea: UIView!
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var userEmail: UILabel?
    
    @IBOutlet weak var myOrderCount: UILabel?
    @IBOutlet weak var myCouponCount: UILabel?
    @IBOutlet weak var myBasketCount: UILabel!
    
    @IBOutlet weak var topButtonArea: uiViewSetting!
    @IBOutlet weak var buttonList: UITableView?
    
    @IBOutlet weak var leftBar: UIView!
    @IBOutlet weak var rightBar: UIView!
    
    let bottomTabBarInfo = BottomTabBarController()
    var buttons = [ [" ", "입점요청", "1:1 문의"], [" ","비밀번호 변경", "이메일 변경"], [" ","이용약관", "개인정보 처리방침", "위치정보이용약관"] ]
    var buttonsSectionHeight : CGFloat = 12.0
    var basketOrder = [Order]()
    var basketCount : Int = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
        
        setUserName()
        setMyCountInfo()
        
        addGest()
        
        buttonList?.dataSource = self
        buttonList?.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let flexWidth = (topButtonArea.frame.size.width / 3)
        leftBar.frame = CGRect(x: flexWidth, y: 10, width: 1, height: 40)
        rightBar.frame = CGRect(x: flexWidth * 2, y: 10, width: 1, height: 40)
        
//        logoutBtn.layer.shadowColor = UIColor.gray.cgColor
        logoutBtn.layer.backgroundColor = UIColor.white.cgColor
//        logoutBtn.layer.shadowOpacity = 1
//        logoutBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
    
        let yPosition = ((buttonList?.contentSize.height)! - (buttonList?.frame.height)!)
        logoutBtn.transform = CGAffineTransform(translationX: 0, y: yPosition)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func addGest() {
        couponArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCoupon(_:))))
        basketArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToBasket(_:))))
        OrderArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToOrder(_:))))
    }
    func setMyCountInfo() {
        basketOrder = loadBasket()
        if (basketOrder.isEmpty || basketOrder.count == 0 ) {
            self.myBasketCount?.text = "0 건"
        }
        else {
            myBasketCount.text = "\(basketCount)"
        }
        networkModel.post(method: .get, param: nil, url: networkURL.orderCount+"\(userPhone)") { (json) in
            if json["result"].boolValue {
                self.myOrderCount?.text = "\(json["total_orders"].intValue) 건"
            }
            else {
                self.myOrderCount?.text = "0 건"
            }
        }
        networkModel.post(method: .get, param: nil, url: networkURL.couponCount+"\(userPhone)") { (json) in
            if json["result"].boolValue {
                self.myCouponCount?.text = "\(json["coupon_count"].intValue) 건"
            }
            else {
                self.myCouponCount?.text = "0 건"
            }
        }
    }
    func setUserName() {
        let user_name = "\(UserDefaults.standard.value(forKey: "user_name") as! String)"
        if user_name != "" {
            userName?.text = "\(user_name)"
        }
        let user_email = "\(UserDefaults.standard.value(forKey: "user_email") as! String)"
        if user_email != "" {
            userEmail?.text = "\(user_email)"
            
        }
    }
    @objc func goToCoupon(_ sender : UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        vc.moveFromOutSide = true
        vc.controllerStoryboard = bottomTabBarInfo.couponPageStoryBoard
        vc.controllerIdentifier = bottomTabBarInfo.couponPageControllerIdentifier
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    @objc func goToBasket(_ sender : UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        if(UserDefaults.standard.value(forKey: "basket") == nil || UserDefaults.standard.value(forKey: "basket") as! String == "" || basketCount == 0) {
            let notExist = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: "NothingExist") as! NothingExist
            notExist.modalTransitionStyle = .crossDissolve
            notExist.modalPresentationStyle = .overFullScreen
            present(notExist, animated: false, completion: nil)
            return
            
        }else{
            vc.controllerStoryboard = bottomTabBarInfo.basketStoryBoard
            vc.controllerIdentifier = bottomTabBarInfo.basketControllerIdentifier
            let store_id = UserDefaults.standard.value(forKey: "currentStoreId")
            if store_id == nil {
                return
            } else if store_id as? String == ""{
                return
            }else{
                networkModel.get(method: .get, url: networkURL.reloadStoreDiscount + String(store_id as! Int)) {json in
                    if json["result"].boolValue {
                        let discount_rate = json["discount_rate"].intValue
                        let data = ["jsonToOrder" : self.loadBasket(),"discount_rate" : discount_rate] as [String : Any]
                        vc.controllerSender = data
                        vc.moveFromOutSide = true
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        return
                    }
                }
            }
//            let data = ["jsonToOrder" : self.loadBasket(),"discount_rate" : BottomTabBarController.discount_rate] as [String : Any]
//            vc.controllerSender = data
//            vc.moveFromOutSide = true
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: false, completion: nil)
        }
    }
    @objc func goToOrder(_ sender : UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        vc.moveFromOutSide = true
        vc.controllerIdentifier = bottomTabBarInfo.orderHistoryControllerIdentifier
        vc.controllerStoryboard = bottomTabBarInfo.orderHistoryStoryBoard
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    @IBAction func logoutBtnClick() {
        
        self.performSegue(withIdentifier: "LogoutDialog", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.restorationIdentifier == "LogoutDialog") {
            let vc = segue.destination as! LogoutDialog
            vc.delegate = self
        }else if let nextViewController = segue.destination as? TermOfUser {
            let type = sender as! String
            nextViewController.type = type
        }
    }
    
    func loadBasket() -> [Order]{
        let decoder = JSONDecoder()
        var jsonToOrder = [Order]()
        if let getData = UserDefaults.standard.value(forKey: "basket") as? String {
            let data = getData.data(using: .utf8)!
            jsonToOrder = try! decoder.decode([Order].self, from: data)
        }
        return jsonToOrder
    }
}
extension MyPageController : UITableViewDelegate, UITableViewDataSource, ClickLogoutDialogDelegate {
    func clickYesBtnDelegate() {
        if (UserDefaults.standard.bool(forKey: "checkedBox") ) {
            UserDefaults.standard.removeObject(forKey: "basket")
            UserDefaults.standard.removeObject(forKey: "user_email")
            UserDefaults.standard.removeObject(forKey: "user_name")
            UserDefaults.standard.removeObject(forKey: "user_phone")
        }
        else {
            UserDefaults.resetStandardUserDefaults()
            UserDefaults.standard.removeObject(forKey: "basket")
            UserDefaults.standard.removeObject(forKey: "user_email")
            UserDefaults.standard.removeObject(forKey: "user_name")
            UserDefaults.standard.removeObject(forKey: "user_phone")
        }
        let storyboard = UIStoryboard(name: "LoginPage", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        //        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.mainPageControllerIdentifier
        //        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.mainPageStoryBoard
                ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.newMainPageControllerIdentifier
                ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.newMainPageStoryBoard
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "LoginPage", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "LoginPageController")
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons[section].count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageButtons", for: indexPath) as! MyPageButtons
        cell.lists?.text = buttons[indexPath.section][indexPath.row + 1]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return buttonsSectionHeight
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return buttons[section][0]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 5))
        headerView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
//            case 0 : self.performSegue(withIdentifier: "NoticePageController", sender: nil)
            case 0 : UIApplication.shared.open(URL(string:"https://pf.kakao.com/_bYeuK/chat")!)
            case 1 : UIApplication.shared.open(URL(string:"https://pf.kakao.com/_bYeuK/chat")!)
            default : return
            }
        case 1 :
            switch indexPath.row {
            case 0 : self.performSegue(withIdentifier: "ChangePass", sender: nil)
            case 1 : self.performSegue(withIdentifier: "ChangeEmail", sender: nil)
            default : return
            }
        case 2 :
            switch indexPath.row {
            case 0 : self.performSegue(withIdentifier: "TermOfUser", sender: TermOfUser.TERMS)
            case 1 : self.performSegue(withIdentifier: "TermOfUser", sender: TermOfUser.PRIVACY)
            case 2 : self.performSegue(withIdentifier: "TermOfUser", sender: TermOfUser.LOCATION)
            default : return
            }
        default : return
        }
    }
}

