//
//  Order.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/04.
//

import Foundation
struct Order {
    var menu = Menu()
    var Essentials = [String : Extra]()
    var nonEssentials = [String : SelectedExtra]()
    var menu_count = 0
    var menu_total_price = 0
    init(menu : Menu,essentials : [String : Extra],nonEssentials : [String : SelectedExtra] ) {
        self.menu = menu
        self.Essentials = essentials
        self.nonEssentials = nonEssentials
    }
}
