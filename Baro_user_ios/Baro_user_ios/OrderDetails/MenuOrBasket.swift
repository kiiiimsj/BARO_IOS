//
//  MenuOrBasket.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/21.
//

import UIKit



protocol TurnOffOrderDetailListener : class {
    func tapClick(goWhere: UIViewController,type: String)
}

class MenuOrBasket : UIViewController {
    public static let ABOUTSTORE = "AboutStore"
    public static let BasketController = "BasketController"
    
    public var temp : OrderDetailsController?
    public var clickListener : TurnOffOrderDetailListener?
    public var basketData : Order?
    public var OrderDetailData : String?
    @IBOutlet weak var OrderDetailBtn: UIButton!
    @IBOutlet weak var BasketBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func pressOrderDetail(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "AboutStore", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "AboutStore") as! AboutStore
//        guard let pvc = self.presentingViewController else { return }
//        vc.store_id = OrderDetailData!
//        clickListener?.tapClick(goWhere: vc,type: MenuOrBasket.ABOUTSTORE)
//        self.dismiss(animated: false) {
////            vc.modalPresentationStyle = .fullScreen
////            pvc.present(vc, animated: false, completion: nil)
//            pvc.dismiss(animated: false)
//        }
    }
    @IBAction func pressBasket(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "BasketController") as! BasketController
//        guard let pvc = self.presentingViewController else { return }
//        vc.menu = basketData
        clickListener?.tapClick(goWhere: UIViewController(),type: MenuOrBasket.BasketController)
//        self.dismiss(animated: false) {
//            vc.modalPresentationStyle = .fullScreen
//            pvc.present(vc, animated: false, completion: nil)
////            pvc.dismiss(animated: false)
//        }
    }
}
