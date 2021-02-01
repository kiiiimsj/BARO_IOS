//
//  NewMainPageController.swift
//  BARO
//
//  Created by . on 2021/02/01.
//

import UIKit
import Alamofire
import SwiftyJSON
import NMapsMap
import FSPagerView

class NewMainPageController: UIViewController, CLLocationManagerDelegate {
    public static let TAG = "MainPageController"
    // 에뮬테스트용 위도/경도
    public static let DEFAULTLATITUDE = 37.49808785857802
    public static let DEFAULTLONGITUDE = 127.02758604547965
    var latitude: Double?
    var longitude: Double?
    var storeList = [StoreList]()
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
    
    let bottomTabBarInfo = BottomTabBarController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var mainView: UIView!
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var eventList = [EventListModel]()
    var userPhone = UserDefaults.standard.value(forKey: "user_phone") as? String
    //blur view
    
    //alert이미지 - 아래에서 off/on체크해주기
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var collectionview: UICollectionView!
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
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserNotReadAlertCount()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,name: UIApplication.willEnterForegroundNotification,object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(refreshControl)
        
        self.definesPresentationContext = true
        getUserNotReadAlertCount()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.layer.cornerRadius = 5
//        pagerControl.layer.cornerRadius = 5
//        collectionViewEvent.dataSource = self
        collectionview.delegate = self
        collectionview.dataSource = self

        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        
        //회원의 위도/경도
        if coor == nil {
            latitude = MainPageController.DEFAULTLATITUDE
            longitude = MainPageController.DEFAULTLONGITUDE
        }else{
            latitude = coor?.latitude
            longitude = coor?.longitude
        }
        
        //회원의 위도경도 model을 userdefaults에 저장 ( 제일 아래에 구조체에 저장)
        //location이라는 key로 위도경도 저장
        let location = Location(latitude: latitude, longitude: longitude)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(location), forKey: "location")
        getMyLocation(String(longitude!), String(latitude!))
        whereAmI = CLLocation(latitude: latitude!, longitude: longitude!)
        
        netWork.post(method: .get, url: urlMaker.eventList) { json in
            var eventModel = EventListModel()
            for item in json["event"].array! {
                eventModel.event_id = item["event_id"].stringValue
                eventModel.event_image = item["event_image"].stringValue
               
                self.eventList.append(eventModel)
            }
            self.setFSPager()
            self.pagerView.reloadData()
            
        }
        let jsonObject : [ String : Any ] = [
            "latitude" : latitude!,
            "longitude" : longitude!
        ]
        netWork.post(method: .post,param: jsonObject, url: urlMaker.findAllStore) { json in
            var storeListModel = StoreList(store_image: "",is_open: "",distance: 0.0,store_id: 0,store_info: "",store_location: "",store_name: "")
            if json["result"].boolValue {
                for item in json["store"].array! {
                    storeListModel.store_image = item["store_image"].stringValue
                    storeListModel.is_open = item["is_open"].stringValue
                    storeListModel.distance = item["distance"].doubleValue
                    storeListModel.store_id = item["store_id"].intValue
                    storeListModel.store_info = item["store_info"].stringValue
                    storeListModel.store_location = item["store_location"].stringValue
                    storeListModel.store_name = item["store_name"].stringValue
                    self.storeList.append(storeListModel)
                }
//                var newFrame = self.collectionview.frame
//                newFrame.size.height = CGFloat(self.storeList.count * 200)
//                self.collectionview.frame = newFrame
                self.collectionview.reloadData()
                let issueLabelsHeightConstraint = self.collectionview.heightAnchor.constraint(
                    equalToConstant: CGFloat(self.storeList.count * 90))
                issueLabelsHeightConstraint.isActive = true
            }
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
        getMyLocation(String(location.coordinate.longitude), String(location.coordinate.latitude))
//        locationManager.stopUpdatingLocation()
    }
    
    //기기의 gps 꺼져있을때
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            //위치권한 거부되어있을 경우
            locationCheck()
            latitude = MainPageController.DEFAULTLATITUDE
            longitude = MainPageController.DEFAULTLONGITUDE
        }
        else if status == CLAuthorizationStatus.authorizedAlways {
            //위치 권한 항상
            let coor = manager.location?.coordinate
            latitude = coor?.latitude
            longitude = coor?.longitude
            
        }
        else if status == CLAuthorizationStatus.authorizedWhenInUse {
            //앱 실행중일시에만
            let coor = manager.location?.coordinate
            latitude = coor?.latitude
            longitude = coor?.longitude
        }
        let location = Location(latitude: latitude, longitude: longitude)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(location), forKey: "location")
        getMyLocation(String(longitude!), String(latitude!))
        whereAmI = CLLocation(latitude: latitude!, longitude: longitude!)

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
    @objc func willEnterForeground() {
        
//        locationCheck()
    }
    //기기의 gps (위치권한 설정) 안함 되어있을경우 alert띄워 앱의 위치권한 설정으로
    func locationCheck() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.notDetermined {
            let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정화면으로 가시겠습니까? ", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) {
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                }
                else {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                }
            }
            let cancelAction = UIAlertAction(title: "아니오", style: .cancel ){
                (action : UIAlertAction) in
                alter.dismiss(animated: true, completion: nil)
            }
            alter.addAction(logOkAction)
            alter.addAction(cancelAction)
            self.present(alter, animated: true, completion: nil)
        }
    }
}

//FSPager 관련
extension NewMainPageController : FSPagerViewDelegate , FSPagerViewDataSource {
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
//        cell.imageView?.contentMode = .scaleAspectFit
//        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goStore(_:))))
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




extension NewMainPageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let store = storeList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
        cell.textLabel.text = String(store.store_name)
        cell.imageView.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + String(store.store_image)))
        if store.is_open == "Y" {
            cell.is_OpenLable.text = "영업중"
            cell.is_OpenLable.backgroundColor = UIColor.init(cgColor: CGColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1))
        }else{
            cell.is_OpenLable.text = "준비중"
            cell.is_OpenLable.backgroundColor = UIColor.init(cgColor: CGColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1))
        }
        cell.is_OpenLable.layer.borderColor = UIColor.white.cgColor
        cell.is_OpenLable.layer.borderWidth = 2
        cell.is_OpenLable.layer.cornerRadius = 5
        cell.is_OpenLable.layer.masksToBounds = true
        if Int(store.distance) > 1000 {
            cell.distance_Label.text = String(Double(Int(store.distance/100) / 10)) + "km"
        }else{
            cell.distance_Label.text = String(Int(store.distance)) + "m"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionview.frame.width, height: 100)
    }
    
}
//클릭에 해당하는 extension들
extension NewMainPageController : CellDelegateEvent, CellDelegateType, CellDelegateUltra, CellDelegateNewStore {
    func tapClickEvent(tag: String) {
        navigationController?.pushViewController(EventPageController(), animated: false)
        performSegue(withIdentifier: "mainToEvent", sender: tag)
    }
    func tapClickType(tag: String) {
        self.toStoreListUseBottomBar(tag: tag)
    }
    
    func tapClickUltra(tag: Int) {
        self.toAboutStoreUseBottomBar(tag: tag)
    }
    
    func tapClickNewStore(tag: Int) {
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


