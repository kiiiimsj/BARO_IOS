//
//  OrderStatusDetailModel.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/29.
//

import Foundation

struct OrderStatusDetailList {
    var order_count = 0
    var menu_name = ""
    var menu_defaultprice = 0
    var OrderStatusDetailExtra = [OrderStatusDetailExtraList]()
    var order_id = 0
    var order_state = ""
    var requests = ""
}
