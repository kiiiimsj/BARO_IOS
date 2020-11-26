//
//  BootPayController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/03.
//

import UIKit
import SwiftyBootpay
import SwiftyJSON

class MyBootPayController : UIViewController {
    let netWork = CallRequest()
    let urlMaker = NetWorkURL()
    var result : Bool = false
    
    public var myOrders = [Order]()
    public var couponId : Int = -1
    var customerRequest = ""
    public var totalPrice : Int = 0
    public var couponDiscountValue : Int = 0
    public var realPrice : Int = 0
    
    
    private let userPhone : String = UserDefaults.standard.value(forKey: "user_phone") as! String
    private let userEmail : String = UserDefaults.standard.value(forKey: "user_email") as! String
    private let userName : String = UserDefaults.standard.value(forKey: "user_name") as! String
    private let sendStoreName : String = UserDefaults.standard.value(forKey: "currentStoreName") as! String
    private let storeId : Int = UserDefaults.standard.value(forKey: "currentStoreId") as! Int
    private var receptId = ""
    
    
    private var setPayLoadNameBuilder : String = ""
    
    private var payDate : String = ""
    private var userToken : String? = nil //서버에서 받아온 userToken
    private let UnknownValue : Int = -1 // 성별을 위한 value
    
    let bottomTabBarInfo = BottomTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("orders : ", myOrders)
        getUserToken() // get user token from baro_server
    }
    
    func getUserToken() {
        //UserDefault에 저장되어 있는 userPhone 여부확인
        if (self.userPhone != "") {
            let param = ["phone":"\(self.userPhone)","user_id":"\(self.userPhone)"]
            netWork.post(method: .post, param: param, url: urlMaker.getUserToken) {
                json in
                print("getUserToken : ", json)
                //UserToken 여부 확인 1
                if (json["user_token"].stringValue != "") {
                    self.userToken = json["user_token"].stringValue
                    self.payDate = json["expired_localtime"].stringValue
                    //user 정보를 주고 user token을 받아오는데 성공한다면
                    //결제할 아이템이 대한 정보 입력
                    self.goBuy()
                }
            }
        }
        //UserDefault에 userPhone이 없다면 에러 처리
        else {
            print("get_user_token_fail")
        }
        //나이스페이에 저장된 카드를 불러오기 위한 값 설정
        //userPhone과 userEmail 모두 존재해야함.
        if(self.userPhone != "" && self.userEmail != "" && self.userName != "" && self.sendStoreName != "") {
            //UnknownValue = -1 = 성별모름
            //stringValue = "" 인것은 필수 입력사항이 아니고 baro_server에 저장된 사항도 아닌것.
            BootpayAnalytics.postLogin(id: self.userPhone, email: self.userEmail, gender: UnknownValue, birth: "", phone: self.userPhone, area: "")
        }
        //userPhone과 userEmail 둘중 하나라도 값이 없을 시 에러 처리
        else {
            print("user_default_value_empty")
        }
    }
    
    //결제 아이템 설정
    func goBuy() {
        //구매정보에 띄워주는 이름 설정 가게이름:메뉴1이름/메뉴2이름/메뉴3이름... 형식으로 저장된다.
        self.setPayLoadNameBuilder = self.sendStoreName + ":"
        var bootPayItems = [BootpayItem]()
        let payload = BootpayPayload()
        let bootUser = BootpayUser()
        for order in myOrders {
            let item = BootpayItem().params {
                $0.item_name = order.menu.menu_name
                $0.qty = order.menu_count
                $0.unique = "\(order.menu.menu_id)"
                $0.price = Double((order.menu.menu_defaultprice))
            }
            //메뉴이름들 추가
            self.setPayLoadNameBuilder.append(order.menu.menu_name + "/")
            bootPayItems.append(item)
        }
        // 구매자 정보
        bootUser.params {
            $0.username = self.userName
            $0.email = self.userEmail
            $0.area = "" // 사용자 주소
            $0.phone = self.userPhone
        }
        payload.params {
            $0.name = self.setPayLoadNameBuilder
            $0.order_id = self.payDate + self.userName
            print("payload_order_id : ", $0.order_id)
            $0.price = Double((self.realPrice))
            //UserToken 여부 확인 2
            if let getUserToken = self.userToken {
                print("getUser?? : ", getUserToken)
                $0.user_token = getUserToken
            }
            else {
                print("getUserTokenError")
                return
            }
            $0.pg = BootpayPG.NICEPAY // 결제할 PG사
            $0.method = BootpayMethod.EASY_CARD
            $0.ux = UX.PG_DIALOG
           //            $0.account_expire_at = "2019-09-25" // 가상계좌 입금기간 제한 ( yyyy-mm-dd 포멧으로 입력해주세요. 가상계좌만 적용됩니다. 오늘 날짜보다 더 뒤(미래)여야 합니다 )
           //            $0.method = "card" // 결제수단
            $0.show_agree_window = false
        }

        let extra = BootpayExtra()
        extra.quotas = [0, 2, 3] // 5만원 이상일 경우 할부 허용범위 설정 가능, (예제는 일시불, 2개월 할부, 3개월 할부 허용
        
        Bootpay.request(self, sendable: self, payload: payload, user: bootUser, items: bootPayItems, extra: extra, addView: true)
    }
}
extension MyBootPayController: BootpayRequestProtocol, PaymentDialogDelegate {
    func clickPaymentCheckBtn() {
        if (self.result) {
            let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
            let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
            
            ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.mainPageControllerIdentifier
            ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.mainPageStoryBoard
            ViewInBottomTabBar.moveFromOutSide = true
            ViewInBottomTabBar.modalPresentationStyle = .fullScreen
            ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
            self.present(ViewInBottomTabBar, animated: true, completion: nil)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    // 에러가 났을때 호출되는 부분
    func onError(data: [String: Any]) {
        print("Payment processing onError : ",data)
        if let getError = data["msg"] as? String ?? "" {
            let errorMessage = getError
            self.createDialog(titleContentString: "결 제 오 류", contentString: "\(errorMessage)", buttonString: "확인")
        }
        self.result = false
        //data로부터 message parsing -> Dialog에 해당 error message 띄우기
    }
    // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.
    func onReady(data: [String: Any]) {
        print("Payment processing onReady : " , data)
    }
    // 결제가 진행되기 바로 직전 호출되는 함수로, 주로 재고처리 등의 로직이 수행
    func onConfirm(data: [String: Any]) {
        print("Payment processing onConfirm : ",data)
        //basketList UserDefault를 가져와서 서버에 보낸다
        //여기서 recept_id가 생성됨
        //data parsing을 통해 recept_id를 받아 DB로 전송
        if let getRecept = data["receipt_id"] as? String ?? "" {
            self.receptId = getRecept
        }
        let param = ["phone":"\(self.userPhone)","recept_id":"\(receptId)"]
        netWork.post(method: .post, param: param, url: urlMaker.checkReceptId) {
            json in
            if json["result"].boolValue {
                
            }
            else {
                return
            }
        }
        var iWantPay = true
        if iWantPay == true {  // 재고가 있을 경우.
            Bootpay.transactionConfirm(data: data) // 결제 승인
        } else { // 재고가 없어 중간에 결제창을 닫고 싶을 경우
            Bootpay.dismiss() // 결제창 종료
        }
    }
    // 결제 취소시 호출
    func onCancel(data: [String: Any]) {
        print("Payment processing onCancel : ",data)
        self.result = false
        self.createDialog(titleContentString: "결 제 오 류", contentString: "결제가 취소되었습니다.", buttonString: "확인")
    }
    // 결제완료시 호출
    // 아이템 지급 등 데이터 동기화 로직을 수행합니다
    func onDone(data: [String: Any]) {
        print("Payment processing onDone : ",data)
        print("print recept_id : ", receptId)
        setOrderInsertParam()
        
    }
    //결제창이 닫힐때 실행되는 부분
    func onClose() {
        print("Payment processing onClose")
        Bootpay.dismiss() // 결제창 종료
        //결제 취소를 알리는 Dialog생성
    }
    func createDialog(titleContentString: String, contentString: String, buttonString: String) {
        let storyboard = UIStoryboard(name: "BootPay", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FinalPaymentCheckDialog") as! FinalPaymentCheckDialog
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.titleContentString = titleContentString
        vc.dialogContentString = contentString
        vc.buttonTitleContentString = buttonString
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func setOrderInsertParam(){
        var sendServerOrderdatas = [SendServerOrders]()
        for order in myOrders {
            var sendServerOrderdata = SendServerOrders()

            for extra in order.Essentials {
                var extraEssentials = Extras()
                extraEssentials.extra_id = extra.value.extra_id
                extraEssentials.extra_count = extra.value.extra_maxcount
                extraEssentials.extra_name = extra.value.extra_name
                extraEssentials.extra_price = extra.value.extra_price
                sendServerOrderdata.extras.append(extraEssentials)
            }
            for extraNon in order.nonEssentials {
                var extraNonEssentials = Extras()
                extraNonEssentials.extra_id = extraNon.value.Extra!.extra_id
                extraNonEssentials.extra_count = extraNon.value.Extra!.extra_maxcount
                extraNonEssentials.extra_name = extraNon.value.Extra!.extra_name
                extraNonEssentials.extra_price = extraNon.value.Extra!.extra_price
                sendServerOrderdata.extras.append(extraNonEssentials)
            }
            sendServerOrderdata.menu_id = order.menu.menu_id
            sendServerOrderdata.menu_defaultprice = "\(order.menu.menu_defaultprice)"
            sendServerOrderdata.menu_name = "\(order.menu.menu_name)"
            sendServerOrderdata.order_count = order.menu_count
            sendServerOrderdatas.append(sendServerOrderdata)
        }
        var param2 = Param()
        param2.phone = self.userPhone
        param2.store_id = self.storeId
        param2.receipt_id = "\(self.receptId)"
        param2.total_price = self.totalPrice
        param2.discount_price = self.couponDiscountValue
        param2.coupon_id = self.couponId
        param2.requests = "\(self.customerRequest)"
        param2.orders = sendServerOrderdatas
        
        var param : [String:AnyObject] = [:]
        let enco = JSONEncoder()
        let jsonData = try? enco.encode(param2)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        print("jsonString : ", jsonString)
        
        param = convertStringToDictionary(text: jsonString)!
        print("param :", param)
        
        self.netWork.post(method: .post, param: param, url: self.urlMaker.orderInsertToServer) {
            json in
            if json["result"].boolValue {
                self.createDialog(titleContentString: "결 제 완 료", contentString: "결제가 완료 되었습니다.", buttonString: "확인")
                //websocket 통신 부분
                self.result = true
                UserDefaults.standard.set("", forKey: "basket")
            }
            else {
                self.createDialog(titleContentString: "결 제 오 류", contentString: "비정상적인 접근입니다.\r\n 결제가 취소 되었습니다.", buttonString: "확인")
            }
        }
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
        print("data : ", data)
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] {
                print("json : ", json)
                return json
            }
        } catch {
               print("Something went wrong")
           }
       }
       return nil
    }
}
