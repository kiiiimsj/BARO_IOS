//
//  EmptyBasket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/22.
//

import UIKit



class EmptyBasket: UIViewController {
    
    
    var menuData : Order?
    var store_id : Int?
    @IBOutlet weak var DialogTop: UILabel!
    var temp : OrderDetailsController?
    @IBOutlet weak var emptyBtn: UIButton!
    @IBOutlet weak var cancel: UIButton!
    var delegate : TurnOffOrderDetailListener!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dialogButtonForm = DialogForm()
        dialogButtonForm.setTopView(top: DialogTop)
        dialogButtonForm.setLeftButton(left: cancel)
        dialogButtonForm.setRightbutton(right: emptyBtn)

    }
    @IBAction func pressEmpty(_ sender: Any) {
        UserDefaults.standard.setValue(store_id, forKey: "currentStoreId")
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
