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
    var delegate : TurnOffOrderDetailListener!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pressEmpty(_ sender: Any) {
        UserDefaults.standard.setValue(String(store_id!), forKey: "currentStoreid")
        UserDefaults.standard.set(nil, forKey: "basket")
        
        self.dismiss(animated: true) {
            self.delegate?.tapClick(dialog: self, type: "")
        }
    }
    @IBAction func pressCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tapCancel(dialog: self)
        }
    }
}
