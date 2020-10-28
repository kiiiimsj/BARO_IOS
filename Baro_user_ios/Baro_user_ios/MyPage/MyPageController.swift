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
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var userEmail: UILabel?
    
    @IBOutlet weak var myOrderCount: UILabel?
    @IBOutlet weak var myCouponCount: UILabel?
    @IBOutlet weak var myBasketCount: UILabel?
    
    @IBOutlet weak var buttonList: UITableView?
    
    var buttons = [ [" ", "공지사항", "입점요청", "1:1 문의"], [" ","비밀번호 변경", "이메일 변경"], [" ","이용약관", "개인정보 처리방침"] ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserName()
        setMyCountInfo()
        buttonList?.dataSource = self
        buttonList?.delegate = self
    }
    func setMyCountInfo() {
        let userPhone = UserDefaults.standard.value(forKey: "user_phone") as! String
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
        // 장바구니는 저장된 UserDefault에서 꺼내오기
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
}
extension MyPageController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons[section].count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageButtons", for: indexPath) as! MyPageButtons
        cell.lists?.text = buttons[indexPath.section][indexPath.row + 1]
        //cell.arrow.kf.setImage()
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return buttons[section][0]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
            case 0 : self.performSegue(withIdentifier: "NoticePageController", sender: nil)
            case 1 : UIApplication.shared.open(URL(string:"http://pf.kakao.com/_bYeuk/chat")!)
            case 2 : UIApplication.shared.open(URL(string:"http://pf.kakao.com/_bYeuk/chat")!)
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
            case 0 : self.performSegue(withIdentifier: "TermOfUser", sender: nil)
            case 1 : self.performSegue(withIdentifier: "TermOfUser", sender: nil)
            default : return
            }
        default : return
        }
    }
}

