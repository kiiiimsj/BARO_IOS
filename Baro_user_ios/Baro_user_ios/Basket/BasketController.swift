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
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad(){
        super.viewDidLoad()
        orders.append(menu)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func clickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clickPay(_ sender: Any) {
        print(totalPriceLabel.text!)
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
        cell.menu_defaultPrice.text = String(eachMenu.menu.menu_defaultprice)
        cell.menu_extra_sum.text = String(eachMenu.menu_total_price)
        cell.menu_totalPrice.text = String(eachMenu.menu_total_price * eachMenu.menu_count)
        cell.extraCollectionView.delegate = cell.self
        cell.extraCollectionView.dataSource = cell.self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BasketHeader", for: indexPath) as! BasketHeader
        return headerview
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(orders[indexPath.item].Essentials.count + orders[indexPath.item].nonEssentials.count)
        return CGSize(width: collectionView.frame.width, height: CGFloat(70 + (orders[indexPath.item].Essentials.count + orders[indexPath.item].nonEssentials.count) * 45))
    }
    
    
}
