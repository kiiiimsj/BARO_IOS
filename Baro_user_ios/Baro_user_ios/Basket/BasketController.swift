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
    public var totalPrice : Int = 0
    public var basket = UserDefaults.standard
    private var getStoreNameFromUserDefault = UserDefaults.standard.value(forKey: "currentStoreName") as! String
    override func viewDidLoad(){
        super.viewDidLoad()
        if (menu != nil) {
            if (basket.value(forKey: "basket") != nil) {
                orders.append(contentsOf: loadBasket())
            }
            orders.append(menu)
        }
        else {
            print("error")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func clickBack(_ sender: Any) {
        saveBasket()
        print("call clickBack")
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
    
    func saveBasket() {
        let encoder = JSONEncoder()
        let jsonSaveData = try? encoder.encode(orders)
        print("jsonConvert : ", jsonSaveData)
        if let _ = jsonSaveData, let jsonString = String(data: jsonSaveData!, encoding: .utf8){
            print("jsonConvertString : ", jsonString)
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
extension BasketController : UICollectionViewDelegate , BasketMenuCellDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("is reload data call this function?")
        let eachMenu = orders[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketMenuCell", for: indexPath) as! BasketMenuCell
        cell.eachMenu = eachMenu
        cell.menu_name.text = eachMenu.menu.menu_name
        cell.menu_count.text = String(eachMenu.menu_count)
        cell.menu_defaultPrice.text = String(eachMenu.menu.menu_defaultprice)
        cell.menu_extra_sum.text = String(eachMenu.menu_total_price)
        cell.menu_totalPrice.text = String(eachMenu.menu_total_price * eachMenu.menu_count)
        cell.extraCollectionView.delegate = cell.self
        cell.extraCollectionView.dataSource = cell.self
        cell.delegate = self
        self.totalPrice += (eachMenu.menu_total_price * eachMenu.menu_count)
        self.totalPriceLabel.text = "\(self.totalPrice)"
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
        print(orders[indexPath.item].Essentials.count + orders[indexPath.item].nonEssentials.count)
        return CGSize(width: collectionView.frame.width, height: CGFloat(70 + (orders[indexPath.item].Essentials.count + orders[indexPath.item].nonEssentials.count) * 45))
    }
    func btnDeleteTapped(cell: BasketMenuCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        //self.totalPrice -= (orders[indexPath!.item].menu_total_price * orders[indexPath!.item].menu_count)
        self.totalPrice = 0
        orders.remove(at: indexPath!.item)
        self.saveBasket()
        self.collectionView.deleteItems(at: [IndexPath(item: indexPath!.item, section: indexPath!.section)])
        self.collectionView.reloadData()
        //self.collectionView.deleteItems(at: [IndexPath(row: indexPath!.row, section: indexPath!.section)])
    }
}
