//
//  StoreListModel.swift
//  BARO_USER
//
//  Created by . on 2020/10/15.
//

import Foundation

struct StoreList : Codable{
    var store_image : String
    var is_open : String
    var distance : Double
    var store_id : Int
    var store_info : String
    var store_location : String
    var store_name : String
    var discount_rate : Int
    
}
