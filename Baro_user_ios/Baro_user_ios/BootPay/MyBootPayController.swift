//
//  BootPayController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/03.
//

import UIKit
import SwiftyBootpay

class MyBootPayController : UIViewController {
    let netWork = CallRequest()
    let urlMaker = NetWorkURL()
    private let userPhone : String = UserDefaults.standard.value(forKey: "user_phone") as! String
    private let userEmail : String = UserDefaults.standard.value(forKey: "user_email") as! String
    private var userToken : String? = nil
    private let UnknownValue : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserToken()
    }
    func getUserToken() {
        let getTokenUrl = "http://3.35.180.57:8080/BillingGetUserToken.do"
        if (self.userPhone != "") {
            let param = ["phone":"\(self.userPhone)","user_id":"\(self.userPhone)"]
            netWork.post(method: .post, param: param, url: getTokenUrl) {
                json in
                print("getUserToken : ", json)
                self.userToken = json["user_token"].stringValue
                self.goBuy()
            }
        }
        else {
            print("get_user_token_fail")
        }
        BootpayAnalytics.init()
        if(self.userPhone != "" && self.userEmail != "") {
            BootpayAnalytics.postLogin(id: self.userPhone, email: self.userEmail, gender: 1, birth: "", phone: self.userPhone, area: "")
        }
        else {
            print("user_default_value_empty")
        }
    }
    func goBuy() {
        // 통계정보를 위해 사용되는 정보
        // 주문 정보에 담길 상품정보로 배열 형태로 add가 가능함
        let item1 = BootpayItem().params {
            $0.item_name = "B사 마스카라" // 주문정보에 담길 상품명
            $0.qty = 1 // 해당 상품의 주문 수량
            $0.unique = "123" // 해당 상품의 고유 키
            $0.price = 1000 // 상품의 가격
        }
        let item2 = BootpayItem().params {
            $0.item_name = "C사 셔츠" // 주문정보에 담길 상품명
            $0.qty = 1 // 해당 상품의 주문 수량
            $0.unique = "1234" // 해당 상품의 고유 키
            $0.price = 10000 // 상품의 가격
            $0.cat1 = "패션"
            $0.cat2 = "여성상의"
            $0.cat3 = "블라우스"
        }

        // 커스텀 변수로, 서버에서 해당 값을 그대로 리턴 받음
        let customParams: [String: String] = [
            "callbackParam1": "value12",
            "callbackParam2": "value34",
            "callbackParam3": "value56",
            "callbackParam4": "value78",
            ]

        // 구매자 정보
        let userInfo: [String: String] = [
            "username": "사용자 이름",
            "email": "user1234@gmail.com",
            "addr": "사용자 주소",
            "phone": "010-1234-4567"
        ]

        // 구매자 정보
        let bootUser = BootpayUser()
        bootUser.params {
           $0.username = "사용자 이름"
           $0.email = "user1234@gmail.com"
           $0.area = "서울" // 사용자 주소
           $0.phone = "010-1234-4567"
        }

        let payload = BootpayPayload()
        payload.params {
           $0.price = 1000 // 결제할 금액
           $0.name = "블링블링's 마스카라" // 결제할 상품명
           $0.order_id = "1234_1234_124" // 결제 고유번호
           $0.params = customParams // 커스텀 변수
            if (self.userToken != nil) {
                print("getUSer?? : ", self.userToken)
                $0.user_token = self.userToken ?? ""
            }
            $0.pg = BootpayPG.NICEPAY // 결제할 PG사
            $0.method = BootpayMethod.EASY_CARD
           $0.ux = UX.PG_DIALOG
           //            $0.account_expire_at = "2019-09-25" // 가상계좌 입금기간 제한 ( yyyy-mm-dd 포멧으로 입력해주세요. 가상계좌만 적용됩니다. 오늘 날짜보다 더 뒤(미래)여야 합니다 )
           //            $0.method = "card" // 결제수단
           $0.show_agree_window = false
        }

        let extra = BootpayExtra()
        extra.quotas = [0, 2, 3] // 5만원 이상일 경우 할부 허용범위 설정 가능, (예제는 일시불, 2개월 할부, 3개월 할부 허용)

        var items = [BootpayItem]()
        items.append(item1)
        items.append(item2)
        Bootpay.request(self, sendable: self, payload: payload, user: bootUser, items: items, extra: extra, addView: true)
    }
}
extension MyBootPayController: BootpayRequestProtocol {
    // 에러가 났을때 호출되는 부분
    func onError(data: [String: Any]) {
        print(data)
    }

    // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.
    func onReady(data: [String: Any]) {
        print("ready")
        print(data)
    }

    // 결제가 진행되기 바로 직전 호출되는 함수로, 주로 재고처리 등의 로직이 수행
    func onConfirm(data: [String: Any]) {
        print(data)

        var iWantPay = true
        if iWantPay == true {  // 재고가 있을 경우.
            Bootpay.transactionConfirm(data: data) // 결제 승인
        } else { // 재고가 없어 중간에 결제창을 닫고 싶을 경우
            Bootpay.dismiss() // 결제창 종료
        }
    }

    // 결제 취소시 호출
    func onCancel(data: [String: Any]) {
        print(data)
    }

    // 결제완료시 호출
    // 아이템 지급 등 데이터 동기화 로직을 수행합니다
    func onDone(data: [String: Any]) {
        print(data)
    }

    //결제창이 닫힐때 실행되는 부분
    func onClose() {
        print("close")
        Bootpay.dismiss() // 결제창 종료
    }
}
