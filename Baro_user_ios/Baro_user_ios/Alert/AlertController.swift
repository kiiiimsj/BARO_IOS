//
//  AlertController.swift
//  Baro_user_ios
//
//  Created by . on 2020/11/06.
//

import UIKit

class AlertController : UIViewController {
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    var Alerts = [AlertModel]()
    @IBOutlet weak var collectinView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectinView.delegate = self
        collectinView.dataSource = self
        netWork.get(method: .get, url: urlMaker.getAlert) { (json) in
            print(json)
            for item in json["alert"].array! {
                var temp = AlertModel()
                temp.alert_id = item["alert_id"].intValue
                temp.alert_title = item["alert_title"].stringValue
                temp.alert_content = item["alert_content"].stringValue
                temp.alert_startdate = item["alert_startdate"].stringValue
                self.Alerts.append(temp)
            }
            self.collectinView.reloadData()
        }
    }
    @IBAction func pressBackBtn(_ sender: Any) {
        self.dismiss(animated: false)
    }
}

extension AlertController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Alerts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlertCell", for: indexPath) as! AlertCell
        let model = Alerts[Alerts.count - indexPath.item - 1]
        cell.title.text = model.alert_title
        cell.content.text = model.alert_content
        cell.date.text = model.alert_startdate
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("12345")
        print(collectionView.frame.width)
        print(view.frame.width)
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    


}
