//
//  MenuOrBasket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/21.
//

import UIKit

protocol TurnOffOrderDetailListener : AnyObject {
    func tapClick(dialog: UIViewController,type: String)
    func tapCancel(dialog: UIViewController)
}

class MenuOrBasket : UIViewController {
    
    @IBOutlet weak var OrderDetailBtn: UIButton!
    @IBOutlet weak var BasketBtn: UIButton!
    var store_id : Int?
    var delegate : TurnOffOrderDetailListener!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(store_id, forKey: "currentStoreId")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    @IBAction func pressOrderDetail(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tapCancel(dialog: self)
        }
    }
    @IBAction func pressBasket(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tapClick(dialog: self, type: "")
        }
    }
}
