//
//  OrderHistoryDetailModel.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/24.
//

import Foundation

struct OrderHistoryDetailList {
    var order_count = 0
    var menu_name = ""
    var menu_defaultprice = 0
    var OrderHistoryDetailExtra = [OrderHistoryDetailExtraList]()
    var order_id = 0
    var order_state = ""
}
