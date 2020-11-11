//
//  SendServerOrders.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/10.
//

import Foundation
struct SendServerOrders : Codable{
    var menu_id = 0
    var menu_name = ""
    var menu_defaultprice = ""
    var order_count = 0
    var extras = [Extras]()
}
struct Extras : Codable {
    var extra_id = 0
    var extra_price = 0
    var extra_name = ""
    var extra_count = 0
}
struct Param : Codable {
    var phone = ""
    var store_id = 0
    var receipt_id = ""
    var total_price = 0
    var discount_price = -1
    var coupon_id = -1
    var requests = ""
    var orders = [SendServerOrders]()
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
}
