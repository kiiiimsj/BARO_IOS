//
//  Basket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/02.
//

import UIKit

class BasketController : UIViewController {
    var menu : Order!
    var orders = [Order]()
    
    var saveOrders : Dictionary<String, [Order]> = [:]
    
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
                orders.append(menu)
            }
            else {
                orders.append(menu)
            }
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func clickBack(_ sender: Any) {
        print("call clickBack")
        self.dismiss(animated: true, completion: nil)
        saveBasket()
    }
    @IBAction func clickPay(_ sender: Any) {
        saveBasket()
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BootPayPage") as! MyBootPayController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.myOrders = self.orders
        self.present(vc, animated: true, completion: nil)
        print(totalPriceLabel.text!)
    }
    
    func saveBasket() {
//        do {
//            print("saveBasket??")
//            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: orders, requiringSecureCoding: false)
//            basket.set(encodedData, forKey: "basket")
//            print("basketList : ", loadBasket())
//            basket.synchronize()
//        }
//        catch {
//            print("error")
//        }
        
//        print("saveBasket??")
//        basket.setValue(orders, forKey: "basket")
//        if (basket.value(forKey: "basket") != nil) {
//            print("basketValue : ", basket.value(forKey: "basket") as! String)
//        }
        self.saveOrders.updateValue(orders, forKey: "basket")
        print("print saveOrders : ",saveOrders)
        print("save to basket")
        basket.set(saveOrders, forKey: "basket")
        print("can load?")
        print(basket.value(forKey: "basket") as! String)
    }
    func loadBasket() -> [Order] {
        let decoded  = UserDefaults.standard.object(forKey: "basket") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Order]
        
        print("decodedTeams : ", decodedTeams)
        
        return decodedTeams
    }
}
extension BasketController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eachMenu = orders[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketMenuCell", for: indexPath) as! BasketMenuCell
        cell.eachMenu = eachMenu
        cell.menu_name.text = eachMenu.menu.menu_name
        cell.menu_count.text = String(eachMenu.menu_count)
        cell.menu_defaultPrice.text = String(eachMenu.menu.menu_defaultprice * eachMenu.menu_count)
        cell.menu_extra_sum.text = String(eachMenu.menu_total_price)
        cell.menu_totalPrice.text = String(eachMenu.menu_total_price * eachMenu.menu_count)
        cell.extraCollectionView.delegate = cell.self
        cell.extraCollectionView.dataSource = cell.self
        self.totalPrice += (eachMenu.menu_total_price * eachMenu.menu_count)
        print("orderCount : ", orders.count)
        print("indexpathRow", indexPath.row)
        if (orders.count == indexPath.row + 1) {
            self.totalPriceLabel.text = "\(self.totalPrice)"
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
        
        return headerview
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(orders[indexPath.item].Essentials.count + orders[indexPath.item].nonEssentials.count)
        return CGSize(width: collectionView.frame.width, height: CGFloat(70 + (orders[indexPath.item].Essentials.count + orders[indexPath.item].nonEssentials.count) * 45))
    }
    
    
}
