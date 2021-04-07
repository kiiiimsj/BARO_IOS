//
//  AppStartDialog.swift
//  BARO
//
//  Created by . on 2021/02/02.
//

import UIKit
protocol AppStartDialogDelegate : class{
    func closeDialog()
}
class AppStartDialog: UIViewController {
    @IBOutlet weak var notTodayBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    private let network = CallRequest()
    private let urlMaker = NetWorkURL()
    private var ads = [AdvertiseModel]()
    public var delegate : AppStartDialogDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        notTodayBtn.layer.borderColor = UIColor.baro_main_color.cgColor
        notTodayBtn.layer.borderWidth = 1
        network.get(method: .get, url: urlMaker.findAdvertise) { [self] json in
            print(json)
            imageView.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageEvent.do?image_name=" + json["event_image"].stringValue), options: [.forceRefresh])
        }
    }
    @IBAction func tapNotToday(_ sender: Any) {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        let dateString = dateFormatter.string(from: today)
        UserDefaults.standard.setValue(dateString, forKey: "notTodayDate")
        delegate?.closeDialog()
        self.dismiss(animated: false, completion: nil)
        
    }
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: false)
        delegate?.closeDialog()
    }
    
}
