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
    
    var latitude: Double?
    var longitude: Double?
    
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
    
    @IBOutlet weak var locationButton: UIButton!
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
        
        locationCheck()
        
        print("main's viewDidLoad")
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        
        //회원의 위도/경도
        latitude = coor?.latitude
        longitude = coor?.longitude
        
        //회원의 위도경도 model을 userdefaults에 저장 ( 제일 아래에 구조체에 저장)
        //location이라는 key로 위도경도 저장
        var location = Location(latitude: latitude, longitude: longitude)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(location), forKey: "location")
        
        //꺼내는 방법 예시
//        if let data = UserDefaults.standard.value(forKey: "location") as? Data {
//            let loca = try? PropertyListDecoder().decode(Location.self, from: data)
//            print("loca",loca)
//        }
        
        getMyLocation(String(longitude!), latitude: String(latitude!))
        whereAmI = CLLocation(latitude: latitude!, longitude: longitude!)
    }
    func getMyLocation(_ longitude : String,latitude :String) {
        myLocation.network.get(method: .get, url: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords="+longitude+","+latitude+"&sourcecrs=epsg:4326&output=json&orders=roadaddr",headers: myLocation.headers) { json in
            let results = json["results"]
            for item in results.array! {
                let region = item["region"]
                let land = item["land"]
                var temp = region["area2"]["name"].stringValue + " "
                temp += region["area3"]["name"].stringValue + " "
                temp += land["addition0"]["value"].stringValue
                self.locationButton.setTitle(temp, for: .normal)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location: CLLocation = locations[locations.count - 1]
        print("dddd",location)
        getMyLocation(String(location.coordinate.longitude),latitude: String(location.coordinate.latitude))
            
    }
    
    //기기의 gps 꺼져있을때
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            //위치권한 거부되어있을 경우
        }
        else if status == CLAuthorizationStatus.authorizedAlways {
            //위치 권한 항상
        }
        else if status == CLAuthorizationStatus.authorizedWhenInUse {
            //앱 실행중일시에만
        }
    }
    
    
    @IBAction func goToMap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "mainToMap") as! MapController
        vc.location = whereAmI
        present(vc, animated: false)
    }
    
    //기기의 gps (위치권한 설정) 안함 되어있을경우 alert띄워 앱의 위치권한 설정으로
    @objc func locationCheck() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정화면으로 가시겠습니까? ", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) {
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                }
                else {
                    UIApplication.shared.canOpenURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
                
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive) {
                (action: UIAlertAction) in
                exit(0)
            }
            alter.addAction(logNoAction)
            alter.addAction(logOkAction)
            self.present(alter, animated: true, completion: nil)
        }
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

struct Location : Codable {
    var latitude: Double!
    var longitude: Double!
}
