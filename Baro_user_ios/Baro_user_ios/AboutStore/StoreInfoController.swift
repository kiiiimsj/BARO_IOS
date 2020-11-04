//
//  StoreMenuController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//

import UIKit
import NMapsMap

class StoreInfoController : UIViewController{
    
    public var netWork : CallRequest!
    public var urlMaker : NetWorkURL!
    public var StoreInfo = StoreInfoModel()
    @IBOutlet weak var storeIntroduce: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var holiday: UILabel!
    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var map: NMFMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        storeIntroduce.text = StoreInfo.store_info
        openTime.text = StoreInfo.store_opentime + " ~ " + StoreInfo.store_closetime
        holiday.text = StoreInfo.store_daysoff
        phonenumber.text = StoreInfo.store_phone
        location.text = StoreInfo.store_location
        
        let storeMarker = NMFMarker(position: NMGLatLng(lat: StoreInfo.store_latitude, lng: StoreInfo.store_longitude), iconImage: NMFOverlayImage(name: "map") )
        storeMarker.mapView = map
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: StoreInfo.store_latitude, lng: StoreInfo.store_longitude))
        cameraUpdate.animation = .easeIn
        map.moveCamera(cameraUpdate)
    }
}
