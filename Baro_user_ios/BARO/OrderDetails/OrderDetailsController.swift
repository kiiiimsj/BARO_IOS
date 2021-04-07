//
//  OrderDetailsController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

class OrderDetailsController : UIViewController {
    public static let me = self
    @IBOutlet weak var menu_image: UIImageView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_price: UILabel!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var goToBasket: UIButton!
    @IBOutlet weak var realPrice: CustomLabel!
    @IBOutlet weak var store_discount_label: DiscountLabel!
    
    private var netWork = CallRequest()
    private var urlMaker = NetWorkURL()
    private var essentials = [String : [Extra]]()
    private var nonEssentials = [Extra]()
    private var categories = [String]()
    @IBOutlet weak var EssentialArea: UICollectionView!
    
    public var menu = Menu()
    public var menu_id = ""
    public var discount_rate : Int = 0
    public var menu_default_price = 0
    public var menu_price_current = 0
    
    public var nonEssentialOpen = false;
    public var selectedEssential = [String : Extra]()
    public var selectedNonEssential = [String : SelectedExtra]()
    
    private var ordersForUserDefault = [Order]()
    public var complete = false
    
    var storeId : Int = 0
    
    var data : Order?
    
    let bottomTabBarInfo = BottomTabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        setMenuInfo()
        menu_price_current = menu.menu_defaultprice
        menu_count.text = "1"
        menu_price.attributedText = menu_price.text?.strikeThrough()
        recalcPrice()
        netWork.get(method: .get, url: urlMaker.extra+"?menu_id="+menu_id) {(json) in
            if json["result"].boolValue{
                for item in json["extra"].array!{
                    var temp = Extra()
                    temp.extra_maxcount = item["extra_maxcount"].intValue
                    temp.extra_name = item["extra_name"].stringValue
                    temp.extra_price = item["extra_price"].intValue
                    temp.extra_id = item["extra_id"].intValue
                    temp.extra_group = item["extra_group"].stringValue
                    if temp.extra_group == "null"{
                        self.nonEssentials.append(temp)
                    }else{
                        if self.essentials[temp.extra_group] == nil{
                            self.essentials[temp.extra_group] = [Extra]()
                            self.categories.append(temp.extra_group)
                        }
                        self.essentials[temp.extra_group]?.append(temp)
                    }
                }
                self.EssentialArea.delegate = self
                self.EssentialArea.dataSource = self
                self.EssentialArea.reloadData()
                self.complete = true
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        reloadOrderDetail()
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear","AboutStore")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @IBAction func AddCount(_ sender: Any) {
        menu_count.text = String(Int(menu_count.text!)! + 1)
        if complete {
            recalcPrice()
        }
    }
    @IBAction func AbstractCount(_ sender: Any) {
        if Int(menu_count.text!) == 1{
            return
        }
        menu_count.text = String(Int(menu_count.text!)! - 1)
        recalcPrice()
    }
    @IBAction func nextPage(_ sender: Any) {
        guard UserDefaults.standard.value(forKey: "user_phone") != nil else{
            let vc = UIStoryboard.init(name: "BottomTabBar", bundle: nil).instantiateViewController(identifier: "GoLoginController")
            self.present(vc, animated: true, completion: nil)
            return
        }
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        if (canGoToNext()){
            data = Order(menu: self.menu, essentials: selectedEssential, nonEssentials: selectedNonEssential)
            data?.menu_count = Int(menu_count.text!)!
            data?.menu_total_price = menu_price_current
            if UserDefaults.standard.value(forKey: "currentStoreId") == nil {
            } // nil  이거때문에 2번 안됨
            if let getStoreId = UserDefaults.standard.value(forKey: "currentStoreId") {
                if(storeId == getStoreId as? Int) {
                    let vc = storyboard.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
                    UserDefaults.standard.setValue(UserDefaults.standard.value(forKey: "tempStoreName") as! String, forKey: "currentStoreName")
                    vc.delegate = self
                    vc.store_id = self.storeId
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: false, completion: nil)
                }else if(getStoreId as? String == ""){
                    let vc = storyboard.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
                    UserDefaults.standard.setValue(UserDefaults.standard.value(forKey: "tempStoreName") as! String, forKey: "currentStoreName")
                    vc.delegate = self
                    vc.store_id = self.storeId
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: false, completion: nil)
                }else if(storeId != getStoreId as? Int){
                    let vc = storyboard.instantiateViewController(identifier: "EmptyBasket") as! EmptyBasket
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.delegate = self
                    vc.store_id = self.storeId
                    self.present(vc, animated: false, completion: nil)
                    
                }
            }
        }
        else {
            let storyboard = UIStoryboard(name: "LoginPage", bundle: nil)
            let dialog = storyboard.instantiateViewController(identifier: "LoginDialog") as! LoginDialog
            dialog.message = "필수 옵션을 선택해주세요."
            dialog.modalPresentationStyle = .overFullScreen
            dialog.modalTransitionStyle = .crossDissolve
            self.present(dialog, animated: true)
        }
    }
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
            
        }
        
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
    func recalcPrice(){
        menu_price.text = String(Int(menu_count.text!)! * menu_price_current )+"원"
        realPrice.text = String(Int(menu_count.text!)! * menu_price_current * (100 - discount_rate) / 100)+"원"
    }
    func canGoToNext() -> Bool{
        if selectedEssential.count == essentials.count{
            return true
        }
        else{
            return false
        }
    }
    func setMenuInfo() {
        self.menu_name.text = self.menu.menu_name
        self.menu_image.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageMenu.do?store_id=\(self.menu.store_id)&image_name=\(self.menu.menu_image)"), options: [.forceRefresh])
        self.menu_price.text = "\(self.menu.menu_defaultprice)"
        self.menu_id = "\(self.menu.menu_id)"
        self.store_discount_label.text = "SALE \(self.discount_rate)%"
    }
}
extension OrderDetailsController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return essentials.count
        case 1:
            return nonEssentials.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let extras = essentials[categories[indexPath.item]]
            let cell = EssentialArea.dequeueReusableCell(withReuseIdentifier: "EssentialCell", for: indexPath) as! EssentialCell
            cell.extras = extras!
            cell.collection.delegate = cell.self
            cell.collection.dataSource = cell.self
            cell.clickListener = self
            cell.optionCategory.text = " · " + (extras?[0].extra_group)!
            if cell.extras.count > 3 {
                cell.whichCell = EssentialCell.OVER3
            }else{
                cell.whichCell = EssentialCell.UNDER3
            }
            return cell
        case 1:
            let cell = EssentialArea.dequeueReusableCell(withReuseIdentifier: "NonEssentialCell", for: indexPath) as! NonEssentialCell
            let extra = nonEssentials[indexPath.item]
            cell.nonEssentialExtras = extra
            cell.optionName.text = " · " + extra.extra_name + "(+\(extra.extra_price)원)"
            cell.clickListner = self
            return cell

        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let extras = essentials[categories[indexPath.item]]
            guard extras == nil else {
                switch extras?.count {
                case 0,1,2,3:
                    return CGSize(width: collectionView.frame.width ,height: 80)
                default:
                    return CGSize(width: collectionView.frame.width, height: CGFloat(70 + extras!.count * 35))
                }
            }
        case 1:
            if self.nonEssentialOpen {
                return CGSize(width: collectionView.frame.width, height: 40)
            }else{
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        default:
            return CGSize()
        }
        return CGSize()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OptionsHeader", for: indexPath) as! OptionsHeader

        switch indexPath.section {
        case 0:
            headerview.header.text = "필수 옵션"
            if essentials.count == 0 {
                headerview.isHidden = true
            }
        case 1:
            if nonEssentials.count == 0 {
                headerview.isHidden = true
            }
            headerview.header.text = "퍼스널 옵션"
            headerview.expandable = true
            headerview.arrow.isHidden = false
            headerview.clickListener = self
            headerview.iPath = indexPath
            // 자신 탭 이벤트 추가하기
            headerview.addGes()
        default:
            return UICollectionReusableView()
        }
        return headerview
      }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension OrderDetailsController : CellDelegateExtra{
    func radioClick(type: Bool, extraPrice: Int,selected: Extra) {
        menu_price_current += extraPrice
        recalcPrice()
        if type {
            selectedEssential[selected.extra_group] = selected
        }
        else{
            selectedEssential.removeValue(forKey: selected.extra_group)
        }
    }
    
    func click(type: Bool, extraPrice: Int,selected: Extra) {
        menu_price_current += extraPrice
        recalcPrice()
        if type {
            selectedEssential[selected.extra_group] = selected
        }
        else{
            selectedEssential.removeValue(forKey: selected.extra_group)
        }
    }
    
}

extension OrderDetailsController : CellDelegateNonExtra{
    func tapNonAdd( extraPrice: Int,selected: Extra) {
        menu_price_current += extraPrice
        recalcPrice()
        if selectedNonEssential[selected.extra_name] == nil {
            let temp = SelectedExtra(extra: selected)
            selectedNonEssential[selected.extra_name] = temp
        }
        selectedNonEssential[selected.extra_name]?.optionCount += 1
    }
    func tapNonAbs( extraPrice: Int,selected: Extra) {
        menu_price_current -= extraPrice
        recalcPrice()
        if selectedNonEssential[selected.extra_name] == nil {
            return
        }
        selectedNonEssential[selected.extra_name]?.optionCount -= 1
        if selectedNonEssential[selected.extra_name]!.optionCount <= 0 {
            selectedNonEssential.removeValue(forKey: selected.extra_name)
        }
    }
}
extension OrderDetailsController : ExpandDelegate {
    func clickExpand(open: Bool, iPath : IndexPath) {
        self.nonEssentialOpen = open
        let layout = EssentialArea.collectionViewLayout
        layout.invalidateLayout()
    }
}

extension OrderDetailsController : TurnOffOrderDetailListener {
    func tapBasket(dialog: UIViewController, type: String) {
        let storyboard2 = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let vc2 = storyboard2.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        
        guard let pvc = self.presentingViewController else { return }
        let loadBasketData = loadBasket()
        self.ordersForUserDefault = loadBasketData["jsonToOrder"] as! [Order]
        self.ordersForUserDefault.append(data!)
        saveBasket(orders: self.ordersForUserDefault)
        UserDefaults.standard.setValue(UserDefaults.standard.value(forKey: "tempStoreName") as! String, forKey: "currentStoreName")
        vc2.controllerIdentifier = self.bottomTabBarInfo.basketControllerIdentifier
        vc2.controllerStoryboard = self.bottomTabBarInfo.basketStoryBoard
        vc2.controllerSender = loadBasket()
        vc2.moveFromOutSide = true
        
        self.dismiss(animated: false) {
            vc2.modalPresentationStyle = .fullScreen
            vc2.modalTransitionStyle = .crossDissolve
            pvc.present(vc2, animated: false, completion: nil)
        }
    }
    func tapBack(dialog: UIViewController) {
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        if let title = dialog.title, title == "EmptyBakset" {
            let basketDialog = storyboard.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
            basketDialog.delegate = self
            self.present(basketDialog, animated: true, completion: nil)
        }
        self.ordersForUserDefault = loadBasket()["jsonToOrder"] as! [Order]
        self.ordersForUserDefault.append(data!)
        saveBasket(orders: self.ordersForUserDefault)
        self.dismiss(animated: false)
    }
    
    func tapCancel(dialog: UIViewController) {
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        if let title = dialog.title, title == "EmptyBakset" {
            let basketDialog = storyboard.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
            basketDialog.delegate = self
            self.present(basketDialog, animated: true, completion: nil)
        }
//        self.ordersForUserDefault = loadBasket()["jsonToOrder"] as! [Order]
//        self.ordersForUserDefault.append(data!)
//        saveBasket(orders: self.ordersForUserDefault)
        self.dismiss(animated: false)
    }
    func tapClick(dialog: UIViewController, type: String) {
        let vc = UIStoryboard(name: "OrderDetails", bundle: nil).instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
        UserDefaults.standard.setValue(UserDefaults.standard.value(forKey: "tempStoreName") as! String, forKey: "currentStoreName")
        vc.delegate = self
        vc.store_id = self.storeId
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    func saveBasket(orders : [Order]) {
        let encoder = JSONEncoder()
        let jsonSaveData = try? encoder.encode(orders)
        if let _ = jsonSaveData, let jsonString = String(data: jsonSaveData!, encoding: .utf8){
            UserDefaults.standard.set(jsonString, forKey: "basket")
            UserDefaults.standard.synchronize()
        }
    }
    func loadBasket() -> [String : Any]{
        let decoder = JSONDecoder()
        var jsonToOrder = [Order]()
        if let getData = UserDefaults.standard.value(forKey: "basket") as? String {
            let data = getData.data(using: .utf8)!
            jsonToOrder = try! decoder.decode([Order].self, from: data)
        }
        let data = ["jsonToOrder" : jsonToOrder,"discount_rate" : discount_rate] as [String : Any]
        return data
    }
}
extension OrderDetailsController {
    func reloadOrderDetail() -> Void {
        netWork.get(method: .get, url: urlMaker.reloadStoreDiscount+String(storeId)) { json in
            if json["result"].boolValue {
                let value = json["discount_rate"].intValue
                self.discount_rate = value
                self.store_discount_label.text = "SALE \(self.discount_rate)%"
                self.recalcPrice()
                BottomTabBarController.activityIndicator.stopAnimating()
            }
        }
    }
    @objc func willEnterForeground() {
        reloadOrderDetail()
    }
}
