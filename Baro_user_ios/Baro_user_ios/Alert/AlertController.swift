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
    let bottomTabBarInfo = BottomTabBarController()
    @IBOutlet weak var collectinView: UICollectionView!
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
                temp.alert_startdate = item["alert_startdate"].stringValue
                self.Alerts.append(temp)
            }
            self.collectinView.reloadData()
        }
    }
}

extension AlertController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Alerts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlertCell", for: indexPath) as! AlertCell
        let model = Alerts[Alerts.count - indexPath.item - 1]
        print("index ROw : ", Alerts.count - indexPath.item - 1)
        cell.title.text = model.alert_title
        cell.date.text = model.alert_startdate
//        var arr =  model.alert_startdate.components(separatedBy: ["년","월","일"]).map{(value) -> String in
//              return String(value)
//        }
//        print("arr : ", arr)
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1).cgColor
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = Alerts[Alerts.count - indexPath.item - 1]
        print("alert indexPath row : ", alert)
        let storyboaard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let vc = storyboaard.instantiateViewController(identifier: "BottomTabBarController") as! BottomTabBarController
        
        vc.controllerSender = alert
        vc.controllerStoryboard = bottomTabBarInfo.alertStoryBoard
        vc.controllerIdentifier = bottomTabBarInfo.alertContentControllerIdentifier
        vc.moveFromOutSide = true
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)
    }
}
