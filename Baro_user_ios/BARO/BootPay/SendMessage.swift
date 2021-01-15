//
//  SendMessage.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/12/30.
//

import Foundation
class SendMessage : Codable {
    var coupon_id = -1
    var discount_price = -1
    var each_count = 1
    var order_date = ""
    var orders = [Order]()
    var phone = ""
    var receipt_id = ""
    var store_id = 0
    var total_price = 0
}
