//
//  Basket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit
import SwiftyJSON
class BasketController : UIViewController, TopViewElementDelegate{
    func favoriteBtnDelegate(controller: UIViewController) {
    }
    func refreshBtnDelegate(controller : UIViewController) {
    }
    public static var this : BasketController?
    var menu : Order!
    var orders = [Order]()
    let netWork = CallRequest()
    let urlMaker = NetWorkURL()
    let store_id = String(UserDefaults.standard.value(forKey: "currentStoreId") as! Int)
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    public var essential = [[Extra]]()
    public var nonEssential = [[SelectedExtra]]()
    public var discount_rate : Int = 0
    public var totalPrice : Int = 0
    public var basket = UserDefaults.standard
    private var getStoreNameFromUserDefault = UserDefaults.standard.value(forKey: "currentStoreName") as! String
    override func viewDidLoad(){
        super.viewDidLoad()
        swipeRecognizer()
        if(orders.count == 0) {
            orders.append(contentsOf: loadBasket())
        }
        optionsSeparate()
        collectionView.delegate = self
        collectionView.dataSource = self
        recalcPrice()
        BasketController.this = self // 원격으로 해당 컨트롤러를 끄기위해
    }
    func optionsSeparate(){
        for item in orders {
            essential.append(Array(item.Essentials.values))
            nonEssential.append(Array(item.nonEssentials.values))
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    @IBAction func clickPay(_ sender: Any) {
        netWork.get(method: .get, url: urlMaker.clarityIsOpen + store_id ) { json in
            if json["result"].boolValue {
                self.saveBasket()
                let storyboard = UIStoryboard(name: "Basket", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "CouponForBasket") as! CouponForBasket
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.totalPrice = self.totalPrice * (100-self.discount_rate)/100
                vc.sendOrderToBootPay = self.orders
                vc.discount_rate = self.discount_rate
                self.present(vc, animated: true, completion: nil)
            }else{
                let vc = UIStoryboard.init(name: "Basket", bundle: nil).instantiateViewController(withIdentifier: "StoreNotOpen")
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    func recalcPrice(){
        self.totalPrice = 0
        for item in orders {
            self.totalPrice += (item.menu_total_price * item.menu_count)
        }
        self.totalPriceLabel.text = "\(self.totalPrice * (100-discount_rate)/100)"
    }
    func saveBasket() {
        let encoder = JSONEncoder()
        let jsonSaveData = try? encoder.encode(orders)
        if let _ = jsonSaveData, let jsonString = String(data: jsonSaveData!, encoding: .utf8){
            basket.set(jsonString, forKey: "basket")
            basket.synchronize()
        }
    }
    func loadBasket() -> [Order]{
        let decoder = JSONDecoder()
        var jsonToOrder = [Order]()
        if let getData = basket.value(forKey: "basket") as? String {
            let data = getData.data(using: .utf8)!
            jsonToOrder = try! decoder.decode([Order].self, from: data)
        }
        return jsonToOrder
    }
}
extension BasketController : UICollectionViewDelegate , BasketMenuCellDelegate, BasketBtnDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eachMenu = orders[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketMenuCell", for: indexPath) as! BasketMenuCell
        cell.essential = essential[indexPath.item]
        cell.nonEssential = nonEssential[indexPath.item]
        cell.extraCollectionView.reloadData()
        cell.menu_name.text = eachMenu.menu.menu_name
        cell.menu_count.text = String(eachMenu.menu_count)
        cell.menu_defaultPrice.text = String(eachMenu.menu.menu_defaultprice)
        cell.menu_extra_sum.text = String(eachMenu.menu_total_price)
        let totalPrice = eachMenu.menu_total_price * eachMenu.menu_count
        cell.menu_totalPrice.text = String(totalPrice) + " 원"
        cell.menu_totalPrice.attributedText = cell.menu_totalPrice.text?.strikeThrough()
        cell.menu_realPrice.text = String(totalPrice * (100-discount_rate)/100) + " 원"
        cell.extraCollectionView.delegate = cell.self
        cell.extraCollectionView.dataSource = cell.self
        cell.delegate = self
        if orders[indexPath.item].Essentials.count > 0 {
            let extraCVHeightContraint = cell.extraCollectionView.heightAnchor.constraint(
                equalToConstant: CGFloat((1+nonEssential[indexPath.item].count) * 20))
            extraCVHeightContraint.isActive = true
        }else{
            let extraCVHeightContraint = cell.extraCollectionView.heightAnchor.constraint(
                equalToConstant: CGFloat((nonEssential[indexPath.item].count) * 20))
            extraCVHeightContraint.isActive = true
        }
        
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BasketHeader", for: indexPath) as! BasketHeader
        if (getStoreNameFromUserDefault != "") {
            headerview.storeName .text = getStoreNameFromUserDefault
        }
        else {
            headerview.storeName .text = "store"
        }
        headerview.store_discount_label.text = "SALE \(self.discount_rate)%"
        return headerview
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orders[indexPath.item].Essentials.count > 0 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(110 + (1 + nonEssential[indexPath.item].count) * 20))
        }else{
            return CGSize(width: collectionView.frame.width, height: CGFloat(110 + (nonEssential[indexPath.item].count) * 20))
        }
//        return CGSize(width: collectionView.frame.width, height: CGFloat(80 + (1 + nonEssential[indexPath.item].count) * 15) )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    func btnDeleteTapped(cell: BasketMenuCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        let dialogController = self.storyboard?.instantiateViewController(identifier: "BasketDialog") as! BasketDialog
        dialogController.deleteItemCount = orders.count
        dialogController.deleteItemPos = indexPath!.item
        dialogController.delegate = self
        dialogController.modalPresentationStyle = .overFullScreen
        dialogController.modalTransitionStyle = .crossDissolve
        self.present(dialogController, animated: true, completion: nil)
        //self.collectionView.reloadSections(IndexSet(integer: 0))
    }
    func tabLeft(index : Int) {
        orders.remove(at: index)
        essential.remove(at: index)
        nonEssential.remove(at: index)
        self.saveBasket()
        if(orders.count == 0) {
            self.dismiss(animated: false, completion: nil)
        }
        self.totalPrice = 0
        recalcPrice()
        self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        self.collectionView.reloadData()
    }
    
    func tabRight(index : Int) {
    }
}
extension BasketController {
    func reloadBasket() -> Void {
        netWork.get(method: .get, url: urlMaker.reloadStoreDiscount+String(store_id)) { json in
            if json["result"].boolValue {
                let value = json["discount_rate"].intValue
                self.discount_rate = value
                self.recalcPrice()
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
//                CouponForBasket.this!.dismiss(animated: false)
                if CouponForBasket.this != nil {
                    CouponForBasket.this!.discountChnage(newValue: self.totalPrice * (100-self.discount_rate)/100,newDiscount_rate: value)
                }
                BottomTabBarController.activityIndicator.stopAnimating()
            }
        }
    }
}
