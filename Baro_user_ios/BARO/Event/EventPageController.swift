//
//  EventPageController.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/10.
//

import UIKit

class EventPageController: UIViewController {
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var content: UILabel!
    var eventId = ""
    @IBOutlet weak var backBtn: UIButton!
    var network = CallRequest()
    var urlMaker = NetWorkURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard (Int(eventId) == nil) else {
            network.get(method: .get, url: urlMaker.eventDetail+eventId) { json in
                if json["result"].boolValue {
                    self.dueDate.text = json["event_startdate"].stringValue+"부터 " + json["event_startdate"].stringValue+"까지"
                    self.content.text = json["event_content"].stringValue
                }
            }
            return
        }
    }
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
