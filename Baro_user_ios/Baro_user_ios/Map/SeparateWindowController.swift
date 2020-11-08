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
    @IBOutlet weak var store_image: UIImageView!
    @IBOutlet weak var goStore: UIButton!
    @IBOutlet weak var Store_address_label: UILabel!
    @IBOutlet weak var Store_distance_label: UILabel!
    @IBOutlet weak var Store_name_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
       
    }
    func whenDidUpdate() -> () {
        netWork.get(method: .get, url: urlMaker.storeIntroductionURL+String(storeData.store_id)) { (json) in
            print(json)
            self.Store_address_label.text = json["store_location"].stringValue
            if self.storeData.distance > 1000 {
                self.Store_distance_label.text = String(format: "%.1f",self.storeData.distance/1000) + " km"
            }else{
                self.Store_distance_label.text = String(format: "%.1f",self.storeData.distance) + " m"
            }
            self.store_image.kf.setImage(with: URL(string: "http://3.35.180.57:8080/imageStore.do?image_name=" + json["store_image"].stringValue))
            self.Store_name_label.text = self.storeData.store_name
            self.goStore.setTitle(self.storeData.store_name + " 으로 가기", for: .normal)
        }
    }
    @IBAction func pressGo(_ sender: Any) {
//        print("go")
//        let vc = self.storyboard?.instantiateViewController(identifier: "goToStore") as! AboutStore
//        vc.store_id = String(self.storeData.store_id)
//        present(vc, animated: false)
//        clickListener.press(end: true)
//        print("end")
    }
    @objc func tap(_ sender: UITapGestureRecognizer) {
        print("go")
        let vc = self.storyboard?.instantiateViewController(identifier: "goToStore") as! AboutStore
        vc.store_id = String(self.storeData.store_id)
        present(vc, animated: false)
        clickListener.press(end: true)
        print("end")
    }
}
