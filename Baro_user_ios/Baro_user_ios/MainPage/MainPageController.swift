//
//  MainPageController.swift
//  Baro_user_ios
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
//    @IBOutlet weak var pagerControl: FSPageControl!
    @IBOutlet weak var collectionViewType: UICollectionView!
    @IBOutlet weak var collectionViewUltra: UICollectionView!
    @IBOutlet weak var collectionViewNewStore: UICollectionView!
    
    let bottomTabBarInfo = BottomTabBarController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var mainView: UIView!
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var eventList = [EventListModel]()
    var userPhone = UserDefaults.standard.value(forKey: "user_phone") as? String
    //blur view
    @IBOutlet weak var aboutHereLabel: UILabel!
    @IBOutlet weak var newStoreThisWeekLabel: UILabel!
    
    //alert이미지 - 아래에서 off/on체크해주기
    @IBOutlet weak var alertButton: UIButton!
    
    lazy var refreshControl: UIRefreshControl = {

            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.baro_main_color
            return refreshControl

        }()
    //alert 클릭시
    @IBAction func alertClick(_ sender: Any) {
        toAlertUseBottomBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserNotReadAlertCount()
        print("룰루")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(refreshControl)
        aboutHereLabel.layer.cornerRadius = 5
        newStoreThisWeekLabel.layer.cornerRadius = 5
        
        self.definesPresentationContext = true
        getUserNotReadAlertCount()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.layer.cornerRadius = 5
//        pagerControl.layer.cornerRadius = 5
//        collectionViewEvent.dataSource = self
        
        collectionViewType.dataSource = self
        collectionViewType.layer.cornerRadius = 5
        collectionViewUltra.dataSource = self
        collectionViewUltra.layer.cornerRadius = 5
        collectionViewNewStore.dataSource = self
        collectionViewNewStore.layer.cornerRadius = 5
        
//        collectionViewEvent.delegate = self
        collectionViewType.delegate = self
        collectionViewUltra.delegate = self
        collectionViewNewStore.delegate = self
        
        
//        locationCheck()
        
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
        let location = Location(latitude: latitude, longitude: longitude)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(location), forKey: "location")
        getMyLocation(String(longitude!), String(latitude!))
        whereAmI = CLLocation(latitude: latitude!, longitude: longitude!)
//        UserDefaults.standard.setValue(0, forKey: "newestAlert")
        netWork.post(method: .get, url: urlMaker.eventList) { json in
            var eventModel = EventListModel()
            print("jj",json)
            for item in json["event"].array! {
                eventModel.event_id = item["event_id"].stringValue
                eventModel.event_image = item["event_image"].stringValue
               
                self.eventList.append(eventModel)
            }
            self.setFSPager()
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
    func getUserNotReadAlertCount() {
        guard let phone = UserDefaults.standard.value(forKey: "user_phone") as? String else{
            
            return
        }
        netWork.get(method: .get, url: urlMaker.getUserNotReadAlertCount+phone) {
            json in
            if json["result"].boolValue {
                if (json["count"].intValue > 0) {
                    print("getUserNotReadaAlertCount : ", json["count"].intValue)
                    self.alertButton.setImage(UIImage(named: "alert_on"), for: .normal)
                    
                }
                else {
                    self.alertButton.setImage(UIImage(named: "alert_off"), for: .normal)
                }
                
            }
            else {
                print("getAlertCount_error")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location: CLLocation = locations[locations.count - 1]
        print("dddd",location)
        getMyLocation(String(location.coordinate.longitude), String(location.coordinate.latitude))
//        locationManager.stopUpdatingLocation()
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
        locationCheck()

    }
    func toStoreListUseBottomBar(tag : String) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.storeListControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.storeListStoryBoard
        ViewInBottomTabBar.controllerSender = tag
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.isModalInPresentation = true
        ViewInBottomTabBar.modalPresentationStyle = .overFullScreen
        ViewInBottomTabBar.modalTransitionStyle = .crossDissolve
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
//        self.navigationController?.pushViewController(ViewInBottomTabBar, animated: false)
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
    }
    func toAboutStoreUseBottomBar(tag : Int) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.aboutStoreControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.aboutStoreStoryBoard
        ViewInBottomTabBar.controllerSender = tag
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.isModalInPresentation = true
        ViewInBottomTabBar.modalPresentationStyle = .overFullScreen
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
    }
    func toAlertUseBottomBar() {
        let phone = UserDefaults.standard.value(forKey: "user_phone")
        guard phone != nil else{
            let vc = UIStoryboard.init(name: "BottomTabBar", bundle: nil).instantiateViewController(identifier: "GoLoginController")
            self.present(vc, animated: true, completion: nil)
            return
        }
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.alertControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.alertStoryBoard
        ViewInBottomTabBar.controllerSender = phone
        ViewInBottomTabBar.moveFromOutSide = true
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = . crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
        
    }
    func setUseTopBarWithBottomTabBarController() {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        vc.controllerIdentifier = bottomTabBarInfo.mapControllerIdentifier
        vc.controllerStoryboard = bottomTabBarInfo.mapPageStoryBoard
        vc.controllerSender = whereAmI!
        vc.moveFromOutSide = true
        vc.isModalInPresentation = true
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    @IBAction func goToMap(_ sender: Any) {
        setUseTopBarWithBottomTabBarController()
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        locationManager.startUpdatingLocation()
        refreshControl.endRefreshing()
    }
    //기기의 gps (위치권한 설정) 안함 되어있을경우 alert띄워 앱의 위치권한 설정으로
    func locationCheck() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.notDetermined {
            let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정화면으로 가시겠습니까? ", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) {
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    let status2 = CLLocationManager.authorizationStatus()
                    print(status2)
                    if status2 != CLAuthorizationStatus.authorizedAlways && status2 != CLAuthorizationStatus.authorizedWhenInUse {
                        self.locationCheck()
                        UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                    }
                }
                else {
                    let status2 = CLLocationManager.authorizationStatus()
                    print(status2)
                    if status2 != CLAuthorizationStatus.authorizedAlways && status2 != CLAuthorizationStatus.authorizedWhenInUse {
                        self.locationCheck()
                        UIApplication.shared.canOpenURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                    }
                }
                
            }
            alter.addAction(logOkAction)
            self.present(alter, animated: true, completion: nil)
        }
    }
}

//FSPager 관련
extension MainPageController : FSPagerViewDelegate , FSPagerViewDataSource {
    // FSPager속성 정하기
    func setFSPager(){
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.itemSize = FSPagerView.automaticSize
        // 무한슬라이딩
        self.pagerView.isInfinite = true
        // 자동슬라이드 주기 ( 1.0 = 1초 )
        self.pagerView.automaticSlidingInterval = 4.0
//        self.pagerControl.numberOfPages = self.eventList.count
//        // 점 위치
//        self.pagerControl.contentHorizontalAlignment = .center
//        // 간격들
//        self.pagerControl.itemSpacing = 8
//        //self.pagerControl.interitemSpacing = 8
//        // 현재 슬라이드 색
//        self.pagerControl.setFillColor(.purple, for: .selected)
//        // 점 크기 정하기
//        self.pagerControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
//        self.pagerControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .selected)
        // 현재위치 / 총 개수
        self.whatPage.text = "1 / " + String(self.eventList.count)
    }
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
    // 광고 클릭
    @objc func goStore(_ sender: UITapGestureRecognizer) {
        let indexPath = self.pagerView.currentIndex
        let eventId = eventList[indexPath].event_id
        navigationController?.pushViewController(EventPageController(), animated: false)
        performSegue(withIdentifier: "mainToEvent", sender: eventId)
    }
    
    // 광고를 직접슬라이딩 했을때
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pagerControl.currentPage = targetIndex
        self.whatPage.text = String(targetIndex + 1) + " / " + String(eventList.count)
    }
    // 광고 애니메이션이 끝났을때 (자동으로 넘어가는 경우도 있기 때문에 필요)
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pagerControl.currentPage = pagerView.currentIndex
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
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewType {
            return CGSize(width: self.collectionViewType.frame.width , height:  collectionView.frame.height)
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
        self.toStoreListUseBottomBar(tag: tag)
    }
    
    func tapClickUltra(tag: Int) {
        print(tag)
        self.toAboutStoreUseBottomBar(tag: tag)
    }
    
    func tapClickNewStore(tag: Int) {
        print(tag)
        self.toAboutStoreUseBottomBar(tag: tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? StoreMenuController {
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

//위도 경도에 해당하는 구조체
struct Location : Codable {
    var latitude: Double!
    var longitude: Double!
}

