//
//  MainPageController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON
import NMapsMap
import FSPagerView

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
    var whatIHave = 0
    var newestAlertNumber : Int!
    lazy var myLocation = MyLocation()
    //table list
    
    @IBOutlet weak var locationButton: UIButton!

    @IBOutlet weak var pagerView: FSPagerView!
    //    @IBOutlet weak var collectionViewEvent: UICollectionView!
    @IBOutlet weak var whatPage: UILabel!
    @IBOutlet weak var pagerControl: FSPageControl!
    @IBOutlet weak var collectionViewType: UICollectionView!
    @IBOutlet weak var collectionViewUltra: UICollectionView!
    @IBOutlet weak var collectionViewNewStore: UICollectionView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet var mainView: UIView!
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var eventList = [EventListModel]()
    //blur view
   
    //alert이미지 - 아래에서 off/on체크해주기
    @IBOutlet weak var alertButton: UIButton!
    //alert 클릭시
    @IBAction func alertClick(_ sender: Any) {
        //alert페이지로 넘기기
//        newestAlertNumber
        UserDefaults.standard.setValue(newestAlertNumber, forKey: "newestAlert")
        let vc = self.storyboard?.instantiateViewController(identifier: "goToAlert") as! AlertController
        present(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        mainView.backgroundColor = .white
        scrollView.backgroundColor = .white
        
        pagerView.dataSource = self
        pagerView.delegate = self
//        collectionViewEvent.dataSource = self
        collectionViewType.dataSource = self
        collectionViewUltra.dataSource = self
        collectionViewNewStore.dataSource = self
        
//        collectionViewEvent.delegate = self
        collectionViewType.delegate = self
        collectionViewUltra.delegate = self
        collectionViewNewStore.delegate = self
        
        
        locationCheck()
        
        print("main's viewDidLoad")
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        
        //회원의 위도/경도
        latitude = coor?.latitude
        longitude = coor?.longitude
        // 에뮬테스트용 위도/경도ㅌ
        latitude = 37.4954847
        longitude = 126.959691
        
        //회원의 위도경도 model을 userdefaults에 저장 ( 제일 아래에 구조체에 저장)
        //location이라는 key로 위도경도 저장
        var location = Location(latitude: latitude, longitude: longitude)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(location), forKey: "location")
        getMyLocation(String(longitude!), String(latitude!))
        whereAmI = CLLocation(latitude: latitude!, longitude: longitude!)
        whetherNewOrNot()
        netWork.post(method: .get, url: urlMaker.eventList) { json in
            var eventModel = EventListModel()
            print("jj",json)
            for item in json["event"].array! {
                eventModel.event_id = item["event_id"].stringValue
                eventModel.event_image = item["event_image"].stringValue
               
                self.eventList.append(eventModel)
            }
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.isInfinite = true
            self.pagerView.automaticSlidingInterval = 4.0
            self.pagerControl.numberOfPages = self.eventList.count
            self.pagerControl.contentHorizontalAlignment = .center
            self.pagerControl.itemSpacing = 8
            self.pagerControl.interitemSpacing = 8
            self.pagerControl.setFillColor(.purple, for: .selected)
            self.pagerControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
            self.pagerControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .selected)
            self.whatPage.text = "1 / " + String(self.eventList.count)
            self.pagerView.reloadData()
            
        }
    }
    
    func getMyLocation(_ longitude : String, _ latitude :String) {
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
        getMyLocation(String(location.coordinate.longitude), String(location.coordinate.latitude))
            
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
extension MainPageController : FSPagerViewDelegate , FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return eventList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let event = eventList[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageEvent.do?image_name=" + event.event_image))
        cell.imageView?.contentMode = .scaleAspectFit
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goStore(_:))))
        return cell
    }
    @objc func goStore(_ sender: UITapGestureRecognizer) {
        let indexPath = self.pagerView.currentIndex
        let eventId = eventList[indexPath].event_id
        navigationController?.pushViewController(EventPageController(), animated: false)
        performSegue(withIdentifier: "mainToEvent", sender: eventId)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pagerControl.currentPage = targetIndex
        self.whatPage.text = String(targetIndex + 1) + " / " + String(eventList.count)
    } 
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pagerControl.currentPage = pagerView.currentIndex
        self.whatPage.text = String(pagerView.currentIndex + 1) + " / " + String(eventList.count)
    }
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
}
extension MainPageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if(collectionView == ) {
//            let cell = collectionViewEvent?.dequeueReusableCell(withReuseIdentifier: "MainPageEvent", for: indexPath) as! MainPageEvent
//            cell.delegateEvent = self
//            return cell
//        }
         if(collectionView == collectionViewType) {
            let cell = collectionViewType?.dequeueReusableCell(withReuseIdentifier: "MainPageType", for: indexPath) as! MainPageType
            cell.delegateType = self
            return cell
        }
        else if(collectionView == collectionViewUltra) {
            let cell = collectionViewUltra?.dequeueReusableCell(withReuseIdentifier: "MainPageUltraStore", for: indexPath) as! MainPageUltraStore
            cell.delegateUltra = self
            return cell
        }
        else {
            let cell = collectionViewNewStore?.dequeueReusableCell(withReuseIdentifier: "MainPageNewStore", for: indexPath) as! MainPageNewStore
            cell.delegateNewStore = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collectionViewEvent {
//            return  CGSize(width: self.collectionViewEvent.frame.width, height: self.collectionViewEvent.frame.height)
//        }
        if collectionView == collectionViewType {
            return CGSize(width: self.collectionViewType.frame.width, height: self.collectionViewType.frame.height)
        }
        else{
            return CGSize(width: self.mainView.frame.width, height: 200)
        }
        
    }
    
}


//클릭에 해당하는 extension들
extension MainPageController : CellDelegateEvent, CellDelegateType, CellDelegateUltra, CellDelegateNewStore {
   
    func tapClickEvent(tag: String) {
        print(tag)
        navigationController?.pushViewController(EventPageController(), animated: false)
        performSegue(withIdentifier: "mainToEvent", sender: tag)
    }
    
    func tapClickType(tag: String) {
        print(tag)
        navigationController?.pushViewController(StoreListPageController(), animated: false)
        performSegue(withIdentifier: "mainToStoreList", sender: tag)
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

        if let nextViewController = segue.destination as? StoreListPageController {
            let labell = sender as! String
            nextViewController.typeCode = labell
            nextViewController.kind = 1
        }
        else if let nextViewController = segue.destination as? StoreMenuController {
            let labell = sender as! String
            nextViewController.store_id = labell
        }
        else if let nextViewController = segue.destination as? EventPageController {
            let labell = sender as! String
            nextViewController.eventId = labell
        }
        else { //이벤트 페이지 만들어지면 전달한 event_id 를 그 페이지로 넘겨주기
            return
        }
        
    }
    
}
extension MainPageController {
    func whetherNewOrNot() -> () {
        let network = CallRequest()
        let urlMaker = NetWorkURL()
        network.get(method: .get, url: urlMaker.getLatest) { (json) in
            print(json)
            self.whatIHave = UserDefaults.standard.integer(forKey: "newestAlert")
            self.newestAlertNumber = json["recentlyAlertId"].intValue
            if self.whatIHave != self.newestAlertNumber {
                print("볼거있음")
                self.alertButton.setImage(UIImage(named: "on"), for: .normal)
            }else{
                print("이미봄")
            }
            print(self.whatIHave)
        }
    }
}

//위도 경도에 해당하는 구조체
struct Location : Codable {
    var latitude: Double!
    var longitude: Double!
}

