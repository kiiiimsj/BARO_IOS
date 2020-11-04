//
//  MapController.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/04.
//

import UIKit
import Alamofire
import NMapsMap

class MapController : UIViewController {
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var location : CLLocation?
    var myLatLng : NMGLatLng?
    var myPin : NMFMarker!
    var StorePins = [NMFMarker]()
    var baroPinImage : NMFOverlayImage!
    var cameraUpdate : NMFCameraUpdate!
    var storeLocations = [LocationModel]()
    @IBOutlet weak var map: NMFMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMyLocation()
        initialzeData()
        
        
    }
    func updateMyLocation() -> Void {
        let myLatitude = Double((location?.coordinate.latitude)!)
        let myLongitude = Double((location?.coordinate.longitude)!)
        myLatLng = NMGLatLng(lat: myLatitude, lng: myLongitude)
        changeCameraShowing(latlng: myLatLng!)
    }
    func initalizeMyPin() ->Void {
        myPin = NMFMarker(position: self.myLatLng!, iconImage: baroPinImage)
        myPin.mapView = map
    }
    func makeStorePin(){
        for item in storeLocations {
            let StorePin = NMFMarker(position: NMGLatLng(lat: item.store_latitude, lng: item.store_longitude), iconImage: baroPinImage)
            StorePin.mapView = map
            StorePins.append(StorePin)
        }
    }
    func changeCameraShowing(latlng : NMGLatLng) -> Void {
        cameraUpdate = NMFCameraUpdate(scrollTo: latlng)
        cameraUpdate.animation = .easeIn
        map.moveCamera(cameraUpdate)
    }
    func initialzeData() -> Void {
        baroPinImage = NMFOverlayImage(name: "map")
        initalizeMyPin()
        var params = Dictionary<String,String>()
        print("dooooo")
        params["latitude"] = String((location?.coordinate.latitude)!)
        params["longitude"] = String((location?.coordinate.longitude)!)
        netWork.post(method: .post, param: params, url: urlMaker.storeLocation){ (json) in
            for item in json["store"].array! {
                var temp = LocationModel()
                temp.store_id = item["store_id"].intValue
                temp.store_name = item["store_name"].stringValue
                temp.store_latitude = item["store_latitude"].doubleValue
                temp.store_longitude = item["store_longitude"].doubleValue
                temp.distance = item["distance"].doubleValue
                self.storeLocations.append(temp)
            }
            self.makeStorePin()
        }
    }
}
