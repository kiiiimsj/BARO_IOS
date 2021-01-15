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
    @IBOutlet weak var DialogTop: UILabel!
    var store_id : Int?
    var delegate : TurnOffOrderDetailListener!
    var dialogButtonForm = DialogForm()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(store_id, forKey: "currentStoreId")
        DialogTop.layer.cornerRadius = 5
        DialogTop.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        DialogTop.layer.masksToBounds = true
        
        dialogButtonForm.setLeftButton(left: OrderDetailBtn)
        dialogButtonForm.setRightbutton(right: BasketBtn)
        
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
