//
//  MainPageController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit
import Alamofire
import NMapsMap
class MainPageController: UIViewController, CLLocationManagerDelegate {
    lazy var locationManager: CLLocationManager = {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = kCLHeadingFilterNone
            manager.requestWhenInUseAuthorization()
            manager.delegate = self
            return manager
        }()
    var whereAmI : CLLocation?
    lazy var myLocation = MyLocation()
    //table list
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableViewEvent: UITableView?
    
    @IBOutlet weak var tableViewType: UITableView?
    
    @IBOutlet weak var tableViewUltra: UITableView?
    
    @IBOutlet weak var tableViewNewStore: UITableView?
    
    
    @IBOutlet var mainView: UIView!
    //blur view
   
    //alert이미지 - 아래에서 off/on체크해주기
    @IBOutlet weak var alertButton: UIButton!
    //alert 클릭시
    @IBAction func alertClick(_ sender: Any) {
        //alert페이지로 넘기기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        tableViewEvent?.separatorStyle = .none
        tableViewType?.separatorStyle = .none
        tableViewUltra?.separatorStyle = .none
        tableViewNewStore?.separatorStyle = .none
        print("main's viewDidLoad")
        locationManager.startUpdatingLocation()
        //        getMyLocation(latitude: "126.9596916", longitude: "37.4954847")
    }
    func getMyLocation(latitude : String,longitude :String) {
        myLocation.network.get(method: .get, url: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords="+latitude+","+longitude+"&sourcecrs=epsg:4326&output=json&orders=roadaddr",headers: myLocation.headers) { json in
            let results = json["results"]
            for item in results.array! {
                let region = item["region"]
                let land = item["land"]
                self.locationLabel.text! = region["area2"]["name"].stringValue + " "
                self.locationLabel.text! += region["area3"]["name"].stringValue + " "
                self.locationLabel.text! += land["addition0"]["value"].stringValue
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location: CLLocation = locations[locations.count - 1]
        print("dddd",location)
            getMyLocation(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
            
        }

    
}

extension MainPageController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableViewEvent){
            let cell = tableViewEvent?.dequeueReusableCell(withIdentifier: "MainPageEvent", for: indexPath) as! MainPageEvent
            cell.delegateEvent = self
            return cell
        }
        else if(tableView == tableViewType){
            let cell = tableViewType?.dequeueReusableCell(withIdentifier: "MainPageType", for: indexPath) as! MainPageType
            cell.delegateType = self
            return cell
        }
        else if(tableView == tableViewUltra){
            let cell = tableViewUltra?.dequeueReusableCell(withIdentifier: "MainPageUltraStore", for: indexPath) as! MainPageUltraStore
            cell.delegateUltra = self
            return cell
        }
        else {
            let cell = tableViewNewStore?.dequeueReusableCell(withIdentifier: "MainPageNewStore", for: indexPath) as! MainPageNewStore
            cell.delegateNewStore = self
            return cell
            
        }
        
    }
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("kkkkkk")
        let vc = LoginPageController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//클릭에 해당하는 extension들

extension MainPageController : CellDelegateEvent, CellDelegateType, CellDelegateUltra, CellDelegateNewStore {
   
    func tapClickEvent(tag: String) {
        print(tag)
        navigationController?.pushViewController(testController(), animated: false)
        performSegue(withIdentifier: "mainToStore", sender: tag)
    }
    
    func tapClickType(tag: String) {
        print(tag)
        navigationController?.pushViewController(StoreListPageController(), animated: false)
        performSegue(withIdentifier: "mainToStore", sender: tag)
    }
    
    func tapClickUltra(tag: String) {
        print(tag)
        navigationController?.pushViewController(testController(), animated: false)
        performSegue(withIdentifier: "mainToStore", sender: tag)
    }
    
    func tapClickNewStore(tag: String) {
        print(tag)
        navigationController?.pushViewController(testController(), animated: false)
        performSegue(withIdentifier: "mainToStore", sender: tag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? StoreListPageController else {
            return
        }
        let labell = sender as! String
        nextViewController.typeCode = labell
    }
}

