//
//  EmptyBasket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/22.
//

import UIKit



class EmptyBasket: UIViewController {
    var menuData : Order?
    var store_id : String?
    var temp : OrderDetailsController?
    @IBOutlet weak var emptyBtn: UIButton!
    @IBOutlet weak var cancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pressEmpty(_ sender: Any) {
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MenuOrBasket") as! MenuOrBasket
        guard let pvc = self.presentingViewController else { return }
        vc.basketData = menuData
        vc.OrderDetailData = String(store_id!)
        UserDefaults.standard.setValue(String(store_id!), forKey: "currentStoreid")
        self.dismiss(animated: false) {
            pvc.present(vc, animated: false, completion: nil)
        }
    }
    @IBAction func pressCancel(_ sender: Any) {
        self.dismiss(animated: true)
        self.temp?.dismiss(animated: false)
    }
}
