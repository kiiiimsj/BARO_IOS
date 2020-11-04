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

    let logInURL = "http://3.35.180.57:8080/MemberLogin.do"
    let signUpURL = "http://3.35.180.57:8080/MemberRegister.do"
    let noticeURL = "http://3.35.180.57:8080/NoticeFindAll.do"
    let phoneNumberCheckURL = "http://3.35.180.57:8080/MemberPhoneCheck.do"
    let passwordUpdateURL = "http://3.35.180.57:8080/MemberPassUpdate.do"
    let emailUpdateURL = "http://3.35.180.57:8080/MemberEmailUpdate.do"
    let categoryURL = "http://3.35.180.57:8080/CategoryFindByStoreId.do"
    let menuURL = "http://3.35.180.57:8080/MenuFindByStoreId.do"
    let menuByCate = "http://3.35.180.57:8080/MenuFindByStoreAndCategoryId.do"


    //store 상세
    let typeListURL = "http://3.35.180.57:8080/TypeFindAll.do"
    let storeDetailListURL = "http://3.35.180.57:8080/StoreInfoFindByType.do"
    let storeIntroductionURL = "http://3.35.180.57:8080/StoreFindById.do?store_id="
    let extra = "http://3.35.180.57:8080/ExtraFindByMenuId.do"
    
    //store 즐겨찾기
    let isFavoriteURL = "http://3.35.180.57:8080/FavoriteExist.do"
    let addFavoriteURL = "http://3.35.180.57:8080/FavoriteSave.do"
    let delFavoriteURL = "http://3.35.180.57:8080/FavoriteDelete.do"

    //coupon 상세

    let couponList = "http://3.35.180.57:8080/CouponFindByPhone.do"
    let couponCount = "http://3.35.180.57:8080/CouponCountByPhone.do?phone="


    //문의 상세
    let requestList = "http://3.35.180.57:8080/InquiryListFindByEmail.do"
    let requestDetail = "http://3.35.180.57:8080/InquiryFindById.do"
    let requestRegist = "http://3.35.180.57:8080/InquirySave.do"


    //주문내역

    let orderList = "http://3.35.180.57:8080/OrderListFindByPhone.do"
    let orderCount = "http://3.35.180.57:8080/OrderTotalCountByPhone.do?phone="


    //나의매장 (즐겨찾기)

    let myStoreList = "http://3.35.180.57:8080/FavoriteList.do"
    //공지 및 이벤트
    let noticeAll = "http://3.35.180.57:8080/NoticeFindAll.do"

    //검색

    let searchList = "http://3.35.180.57:8080/StoreSearch.do"

    // 이미지

    let eventImage = "http://3.35.180.57:8080/ImageEvent.do"
    let storeImage = "http://3.35.180.57:8080/ImageStore.do"
    let storeTypeImage = "http://3.35.180.57:8080/ImageType.do"

    let eventList = "http://3.35.180.57:8080/EventFindAll.do"

    let ultraList = "http://3.35.180.57:8080/StoreFindByUltra.do"
    
    let newStoreList = "http://3.35.180.57:8080/StoreFindByNew.do"
    
    
    //주문내역 리스트 뽑기
    let orderHistoryList = "http://3.35.180.57:8080/OrderListFindByPhone.do"
    
    let orderHistoryRegular = "http://3.35.180.57:8080/OrderFindByReceiptId.do"
    
    //주문현황 default 뽑기
    let orderProgressList = "http://3.35.180.57:8080/OrderProgressing.do"
}

class MyLocation {
    var network = CallRequest()
    var headers : HTTPHeaders!
    var location = "dd"
    init() {
        var keys = [String : String]()
        keys["X-NCP-APIGW-API-KEY-ID"] = (Bundle.main.object(forInfoDictionaryKey: "NMFClientId") as! String)
        keys["X-NCP-APIGW-API-KEY"] = (Bundle.main.object(forInfoDictionaryKey: "NMFClientSecret") as! String)
        headers = HTTPHeaders(keys)
    }
    func getMyLocation(latitude : String,longitude : String) {
        network.get(method: .get, url: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords="+latitude+","+longitude+"&sourcecrs=epsg:4326&output=json&orders=roadaddr",headers: headers) { json in
            let results = json["results"]
            let region = results["region"]
            let land = results["land"]
            let area2 = region["area2"]["name"].stringValue
            let area3 = region["area3"]["name"].stringValue
            let addition = land["area2"]["addition0"]["value"].stringValue
            self.location = area2 + " " + area3 + " " + addition
        }
    }
}
