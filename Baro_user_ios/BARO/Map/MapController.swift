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
    
    @IBOutlet weak var backButton: UIButton!
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var location : CLLocation?
    var myLatLng : NMGLatLng?
    var myPin : NMFMarker!
    var StorePins = [NMFMarker]()
    let infoWindow = NMFInfoWindow()
    let infoWindowDataSource = NMFInfoWindowDefaultTextSource.data()
    var baroPinImage : NMFOverlayImage!
    var cameraUpdate : NMFCameraUpdate!
    let bottomTabBarInfo = BottomTabBarController()
    var storeLocations = [LocationModel]()
    
    var VC : SeparateWindowController!
    @IBOutlet weak var SeparateWindow: UIView!
   
    @IBOutlet weak var map: NMFNaverMapView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        view.addSubview(map)
//        SeparateWindow.layer.borderWidth = 5
//        SeparateWindow.layer.borderColor = UIColor.baro_main_color.cgColor
//        SeparateWindow.layer.cornerRadius = 10
        initializeMapOptions()
        updateMyLocation()
        initialzeData()
        
        map.mapView.touchDelegate = self 
    }
    
    func updateMyLocation() -> Void {
        let myLatitude = Double((location?.coordinate.latitude)!)
        let myLongitude = Double((location?.coordinate.longitude)!)
        myLatLng = NMGLatLng(lat: myLatitude, lng: myLongitude)
        changeCameraShowing(latlng: myLatLng!)
    }
//    func initalizeMyPin() ->Void {
//        myPin = NMFMarker(position: self.myLatLng!, iconImage: baroPinImage)
//        myPin.mapView = map.mapView
//        myPin.captionText = "내 위치"
//        let locationOverlay = map.mapView.locationOverlay
//        locationOverlay.hidden = false
//        locationOverlay.location = myLatLng!
//        locationOverlay.icon = NMFOverlayImage(name: "selected")
//        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
//        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
//        locationOverlay.circleRadius = 50
//    }
    
    func makeStorePin(){
        for item in storeLocations {
            let StorePin = NMFMarker(position: NMGLatLng(lat: item.store_latitude, lng: item.store_longitude), iconImage: baroPinImage)
            StorePin.mapView = map.mapView
            StorePin.userInfo = ["StoreInfo" : item]
            StorePin.captionText = item.store_name
            StorePin.touchHandler = { [weak self] (overlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    if self!.SeparateWindow.isHidden {
                        // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                        let data = marker.userInfo["StoreInfo"] as! LocationModel
//                        self!.infoWindowDataSource.title = data.store_name+"점"
//                        self?.infoWindow.open(with: marker)
                        self?.SeparateWindow.isHidden = false
                        self!.VC.storeData = data
                        self!.VC.whenDidUpdate()
                    } else {
                        // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
//                        self?.infoWindow.close()
                        self?.SeparateWindow.isHidden = true

                    }
                }
                return true
            };
            StorePins.append(StorePin)
            storeLocations.removeAll()
        }
    }
    func changeCameraShowing(latlng : NMGLatLng) -> Void {
        cameraUpdate = NMFCameraUpdate(scrollTo: latlng)
        cameraUpdate.animation = .easeIn
        map.mapView.moveCamera(cameraUpdate)
    }
    func initializeMapOptions(){
       
        map.mapView.positionMode = .direction
        map.showZoomControls = true
   
        map.showCompass = false
        map.showLocationButton = true
        
        
        
    }
    func setWindowEnvironment(){
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        VC = (storyboard.instantiateViewController(withIdentifier: "SeparateWindowController") as! SeparateWindowController)
        
        self.addChild(VC)
        SeparateWindow.addSubview((VC.view)!)
        VC.view.frame = SeparateWindow.bounds
        VC.didMove(toParent: self)
        VC.clickListener = self
        self.view.bringSubviewToFront(self.SeparateWindow)
    }
    func initialzeData() -> Void {
        baroPinImage = NMFOverlayImage(name: "store_marker")
        //initalizeMyPin()
//        infoWindow.dataSource = infoWindowDataSource
        setWindowEnvironment()
        var params = Dictionary<String,String>()
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
    
    @IBAction func pressBackBtn(_ sender: Any) {
        self.dismiss(animated: false)
        
    }
    @IBAction func pressReturn(_ sender: Any) {
        changeCameraShowing(latlng: myLatLng!)
    }
    @objc func returnMe(_ sender: UITapGestureRecognizer) {
        changeCameraShowing(latlng: myLatLng!)
    }
}

extension MapController : NMFMapViewTouchDelegate,NMFMapViewOptionDelegate,NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
        SeparateWindow.isHidden = true
        
    }
}
extension MapController : SWDelegate{
    func press(end: Bool) {
        if end {
//            self.dismiss(animated: false)
        }
    }
}
