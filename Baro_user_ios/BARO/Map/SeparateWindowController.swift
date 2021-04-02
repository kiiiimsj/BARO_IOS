//
//  SeparateWindowController.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/06.
//

import UIKit

protocol SWDelegate {
    func press(end : Bool)
}
class SeparateWindowController : UIViewController {
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var storeData : LocationModel!
    var clickListener : SWDelegate!
    let bottomTabBarInfo = BottomTabBarController()
    @IBOutlet weak var store_image: UIImageView!
//    @IBOutlet weak var goStore: UIButton!
    @IBOutlet weak var Store_address_label: UILabel!
    @IBOutlet weak var Store_distance_label: UILabel!
    @IBOutlet weak var Store_name_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.baro_main_color.cgColor
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
       
    }
    func whenDidUpdate() -> () {
        netWork.get(method: .get, url: urlMaker.storeIntroductionURL+String(storeData.store_id)) { (json) in
            self.Store_address_label.text = json["store_location"].stringValue
            if self.storeData.distance > 1000 {
                self.Store_distance_label.text = String(format: "%.1f",self.storeData.distance/1000) + " km"
            }else{
                self.Store_distance_label.text = String(format: "%.1f",self.storeData.distance) + " m"
            }
            self.store_image.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageStore.do?image_name=" + json["store_image"].stringValue))
            self.Store_name_label.text = self.storeData.store_name
//            self.goStore.setTitle(self.storeData.store_name + " 으로 가기", for: .normal)
        }
    }
    @IBAction func pressGo(_ sender: Any) {
    }
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.aboutStoreControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.aboutStoreStoryBoard
        netWork.get(method: .get, url: urlMaker.reloadStoreDiscount+String(self.storeData.store_id)) { [self] json in
            if json["result"].boolValue {
                let data = ["id" : self.storeData.store_id,"discount_rate" : json["discount_rate"].intValue]
                ViewInBottomTabBar.controllerSender = data
                ViewInBottomTabBar.moveFromOutSide = true
                ViewInBottomTabBar.modalPresentationStyle = .fullScreen
                ViewInBottomTabBar.modalTransitionStyle = .crossDissolve
                UserDefaults.standard.set(self.storeData.store_name, forKey: "tempStoreName")
                guard let pvc = self.presentingViewController else {return}
                self.dismiss(animated: false) {
                    pvc.present(ViewInBottomTabBar, animated: true, completion: nil)
                }
            }
        }
    }
}
