//
//  UrlMaker.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit
import Alamofire
import SwiftyJSON

enum StatusCode : Int {
    case success = 200
    case fail = 500
}


//네트워크 통신

class CallRequest {

    func get(method : HTTPMethod, param: [String : Any]? = nil, url : String ,id : Int? = nil, headers: HTTPHeaders? = nil, success : @escaping(JSON) -> ()) {
        //1.Post Parameter
        AF.request(url, method: method, parameters: param,headers: headers
        ).validate().responseJSON { response in

            let statusCode = StatusCode(rawValue: response.response?.statusCode ?? 500)



            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //2.클로저 = 함수자체를 매개변수로 해주겠다.

                success(json)

                print(json)
            case .failure(let error):

                print(error.errorDescription)
            }


        }


    }

    func post(method : HTTPMethod, param: [String : Any]? = nil,url : String ,id : Int? = nil, success : @escaping(JSON) -> ()) {
        //1.Post Parameter
        AF.request(url, method: method, parameters: param,encoding:JSONEncoding.default
        ).validate().responseJSON { response in

            let statusCode = StatusCode(rawValue: response.response?.statusCode ?? 500)
            switch statusCode {
            case .success:
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //2.클로저 = 함수자체를 매개변수로 해주겠다.

                    success(json)

//                    print(json)
                case .failure(let error):

                    print(error.errorDescription)
                }


            case .fail: print("서버 에러")

            default : print("서버 에러")


            }

        }


    }

}


class NetWorkURL {

    let logInURL = "http://15.165.22.64:8080/MemberLogin.do"
    let signUpURL = "http://15.165.22.64:8080/MemberRegister.do"
    let noticeURL = "http://15.165.22.64:8080/NoticeFindAll.do"
    let phoneNumberCheckURL = "http://15.165.22.64:8080/MemberPhoneCheck.do"
    let passwordUpdateURL = "http://15.165.22.64:8080/MemberPassUpdate.do"
    let categoryURL = "http://15.165.22.64:8080/CategoryFindByStoreId.do"
    let menuURL = "http://15.165.22.64:8080/MenuFindByStoreId.do"
    let menuByCate = "http://15.165.22.64:8080/MenuFindByStoreAndCategoryId.do"


    //store 상세
    let typeListURL = "http://15.165.22.64:8080/TypeFindAll.do"
    let storeDetailListURL = "http://15.165.22.64:8080/StoreInfoFindByType.do"
    let storeIntroductionURL = "http://15.165.22.64.44:8080/StoreFindById.do"
    let extra = "http://15.165.22.64:8080/ExtraFindByMenuId.do"

    //coupon 상세

    let couponList = "http://15.165.22.64:8080/CouponFindByPhone.do"


    //문의 상세
    let requestList = "http://15.165.22.64:8080/InquiryListFindByEmail.do"
    let requestDetail = "http://15.165.22.64:8080/InquiryFindById.do"
    let requestRegist = "http://15.165.22.64:8080/InquirySave.do"


    //주문내역

    let orderList = "http://15.165.22.64:8080/OrderListFindByPhone.do"


    //나의매장 (즐겨찾기)

    let myStoreList = "http://15.165.22.64:8080/FavoriteList.do"


    //검색

    let searchList = "http://15.165.22.64:8080/StoreSearch.do"

    // 이미지

    let eventImage = "http://15.165.22.64:8080/ImageEvent.do"
    let storeImage = "http://15.165.22.64:8080/ImageStore.do"
    let storeTypeImage = "http://15.165.22.64:8080/ImageType.do"

    let eventList = "http://15.165.22.64:8080/EventFindAll.do"

    let ultraList = "http://15.165.22.64:8080/StoreFindByUltra.do"
}

