//
//  StoreMenuController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//

import UIKit

class StoreInfoController : UIViewController{
    
    public var netWork : CallRequest!
    public var urlMaker : NetWorkURL!
    public var StoreInfo = StoreInfoModel()
    @IBOutlet weak var storeIntroduce: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var holiday: UILabel!
    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var location: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        storeIntroduce.text = StoreInfo.store_info
        openTime.text = StoreInfo.store_opentime + " ~ " + StoreInfo.store_closetime
        holiday.text = StoreInfo.store_daysoff
        phonenumber.text = StoreInfo.store_phone
        location.text = StoreInfo.store_location
    }
}
