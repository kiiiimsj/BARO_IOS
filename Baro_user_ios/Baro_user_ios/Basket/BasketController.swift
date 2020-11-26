//
//  Basket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit
import SwiftyJSON
class BasketController : UIViewController {
    var menu : Order!
    var orders = [Order]()
    let netWork = CallRequest()
    let urlMaker = NetWorkURL()
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    public var essential = [[Extra]]()
    public var nonEssential = [[SelectedExtra]]()
    public var totalPrice : Int = 0
    public var basket = UserDefaults.standard
    private var getStoreNameFromUserDefault = UserDefaults.standard.value(forKey: "currentStoreName") as! String
    override func viewDidLoad(){
        super.viewDidLoad()
        if(orders.count == 0) {
            orders.append(contentsOf: loadBasket())
        }
        print("orders : ", orders)
        optionsSeparate()
        collectionView.delegate = self
        collectionView.dataSource = self
        recalcPrice()
    }
    func optionsSeparate(){
        for item in orders {
            essential.append(Array(item.Essentials.values))
            nonEssential.append(Array(item.nonEssentials.values))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    @IBAction func clickBack(_ sender: Any) {
        saveBasket()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clickPay(_ sender: Any) {
        saveBasket()
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CouponForBasket") as! CouponForBasket
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.totalPrice = self.totalPrice
        vc.sendOrderToBootPay = self.orders
        self.present(vc, animated: true, completion: nil)
        print(totalPriceLabel.text!)
    }
    func recalcPrice(){
        for item in orders {
            self.totalPrice += (item.menu_total_price * item.menu_count)
        }
        self.totalPriceLabel.text = "\(self.totalPrice)"
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
        cell.menu_totalPrice.text = String(eachMenu.menu_total_price * eachMenu.menu_count)
        cell.extraCollectionView.delegate = cell.self
        cell.extraCollectionView.dataSource = cell.self
        cell.delegate = self
     
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
        
        return headerview
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orders[indexPath.item].Essentials.count > 0 {
            return CGSize(width: collectionView.frame.width, height: CGFloat(120 + ((1 + nonEssential[indexPath.item].count) * 50)))
        }else{
            return CGSize(width: collectionView.frame.width, height: CGFloat(120 + (nonEssential[indexPath.item].count) * 50))
        }
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
        print("deleteindex : ", index)
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
        print("123123")
    }
}
