//
//  ExtraModel.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import Foundation

struct Extra : Codable{
    var extra_group = "TEMPERATURE"
    var extra_id = 0
    var extra_price = 0
    var extra_name = "ICE"
    var extra_maxcount = 3
}
struct SelectedExtra : Codable {
    var Extra : Extra?
    var optionCount : Int
    init(extra : Extra) {
        Extra = extra
        optionCount = 0
    }
}
