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
    public static let ABOUTSTORE = "AboutStore"
    public static let BasketController = "BasketController"
    
    public var temp = OrderDetailsController()
    public var basketData : Order?
    public var OrderDetailData : String?
    
    @IBOutlet weak var OrderDetailBtn: UIButton!
    @IBOutlet weak var BasketBtn: UIButton!
    
    private var MyPresentedViewController: UIViewController?
    
    var delegate : TurnOffOrderDetailListener!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        MyPresentedViewController = self.presentedViewController
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
