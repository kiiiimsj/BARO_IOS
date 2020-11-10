//
//  SendServerOrders.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/10.
//

import Foundation
struct SendServerOrders : Codable {
    var menu_id = ""
    var menu_name = ""
    var menu_defaultprice = ""
    var order_count = ""
    var extras = [Extras]()
}
struct Extras : Codable {
    var extra_id = ""
    var extra_price = ""
    var extra_name = ""
    var extra_count = ""
}
