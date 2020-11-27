//
//  OrderDetailsController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

class OrderDetailsController : UIViewController {
    public static let me = self
    private static let TAG = "OrderDetailsController"
    @IBOutlet weak var menu_image: UIImageView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_price: UILabel!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var goToBasket: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    private var network = CallRequest()
    private var urlMaker = NetWorkURL()
    private var essentials = [String : [Extra]]()
    private var nonEssentials = [Extra]()
    private var categories = [String]()
    
    @IBOutlet weak var EssentialArea: UICollectionView!
    
    var makeToastMessage = ToastMessage()
    
    public var menu = Menu()
    public var menu_id = ""
    public var menu_default_price = 0
    public var menu_price_current = 0
    
    public var nonEssentialOpen = false;
    public var selectedEssential = [String : Extra]()
    public var selectedNonEssential = [String : SelectedExtra]()
    
    var storeId = UserDefaults.standard.value(forKey: "currentStoreId")
    
    var data : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuInfo()
        backBtn.setImage(UIImage(named: "arrow_back" ), for: .normal)
        menu_price_current = menu.menu_defaultprice
        menu_count.text = "1"
        
        recalcPrice()
        network.get(method: .get, url: urlMaker.extra+"?menu_id="+menu_id) {(json) in
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
            }
        }
    }
    @IBAction func AddCount(_ sender: Any) {
        menu_count.text = String(Int(menu_count.text!)! + 1)
        recalcPrice()
    }
    @IBAction func AbstractCount(_ sender: Any) {
        if Int(menu_count.text!) == 1{
            return
        }
        menu_count.text = String(Int(menu_count.text!)! - 1)
        recalcPrice()
    }
    @IBAction func backBtnPress() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextPage(_ sender: Any) {
        if (canGoToNext()){
            data = Order(menu: self.menu, essentials: selectedEssential, nonEssentials: selectedNonEssential)
            data?.menu_count = Int(menu_count.text!)!
            data?.menu_total_price = menu_price_current
            if (storeId != nil) {
                let vc = self.storyboard?.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: false, completion: nil)

            }else{
                let vc = self.storyboard?.instantiateViewController(identifier: "EmptyBasket") as! EmptyBasket
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.store_id = self.storeId as? String
                self.present(vc, animated: false, completion: nil)
            }
        }
        else {
            self.makeToastMessage.showToast(message: "필수옵션을 선택해 주세요", font: UIFont.init(name: "NotoSansCJKkr-Regular", size: 15.0)!, targetController: self)
        }
    }
    func recalcPrice(){
        menu_price.text = String(Int(menu_count.text!)! * menu_price_current)+"원"
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
        self.menu_image.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageMenu.do?store_id=\(self.menu.store_id)&image_name=\(self.menu.menu_image)"))
        self.menu_price.text = "\(self.menu.menu_defaultprice)"
        self.menu_id = "\(self.menu.menu_id)"
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
            cell.optionName.text = " · " + extra.extra_name
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
                    return CGSize(width: collectionView.frame.width ,height: 120)
                default:
                    return CGSize(width: collectionView.frame.width, height: CGFloat(70 + extras!.count * 35))
                }
            }
        case 1:
            if self.nonEssentialOpen {
                return CGSize(width: collectionView.frame.width, height: 30)
            }else{
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        default:
            return CGSize()
        }
        return CGSize()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
        menu_price.text = String(Int(menu_count.text!)! * menu_price_current)+"원"
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
        print(open)
        self.nonEssentialOpen = open
        print(nonEssentialOpen)
        let layout = EssentialArea.collectionViewLayout
        layout.invalidateLayout()
    }
}

extension OrderDetailsController : TurnOffOrderDetailListener {
    func tapCancel(dialog: UIViewController) {
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        if let title = dialog.title, title == "EmptyBakset" {
            let basketDialog = storyboard.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
            basketDialog.delegate = self
            self.present(basketDialog, animated: true, completion: nil)

        }                
        let vc = storyboard.instantiateViewController(identifier: "BasketController") as! BasketController
        vc.orders = loadBasket()
        vc.orders.append(data!)
        saveBasket(orders: vc.orders)
        self.dismiss(animated: false)
    }
    func tapClick(dialog: UIViewController, type: String) {
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BasketController") as! BasketController
        
        guard let pvc = self.presentingViewController else { return }
        vc.orders = loadBasket()
        vc.orders.append(data!)
        saveBasket(orders: vc.orders)
        self.dismiss(animated: false) {
            vc.modalPresentationStyle = .fullScreen
            pvc.present(vc, animated: false, completion: nil)
        }
    }
    func saveBasket(orders : [Order]) {
        let encoder = JSONEncoder()
        let jsonSaveData = try? encoder.encode(orders)
        if let _ = jsonSaveData, let jsonString = String(data: jsonSaveData!, encoding: .utf8){
            UserDefaults.standard.set(jsonString, forKey: "basket")
            UserDefaults.standard.synchronize()
        }
    }
    func loadBasket() -> [Order]{
        let decoder = JSONDecoder()
        var jsonToOrder = [Order]()
        if let getData = UserDefaults.standard.value(forKey: "basket") as? String {
            let data = getData.data(using: .utf8)!
            jsonToOrder = try! decoder.decode([Order].self, from: data)
        }
        return jsonToOrder
    }
}
