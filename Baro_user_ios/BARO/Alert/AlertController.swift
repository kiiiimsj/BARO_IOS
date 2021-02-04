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
    var userPhone = ""
    let bottomTabBarInfo = BottomTabBarController()
    @IBOutlet weak var collectinView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.Alerts.removeAll()
        collectinView.delegate = self
        collectinView.dataSource = self
        netWork.get(method: .get, url: urlMaker.alertFindAll+userPhone) { (json) in
            if(json["alert"].array != nil) {
                for item in json["alert"].array! {
                    var temp = AlertModel()
                    temp.is_read = item["is_read"].stringValue
                    temp.alert_title = item["alert_title"].stringValue
                    temp.alert_startdate = item["alert_startdate"].stringValue
                    //temp.id = DB 피벗 테이블을 위한 AUTO_INCREMENT PK
                    temp.alert_id = item["alert_id"].intValue
                    self.Alerts.append(temp)
                }
                self.collectinView.reloadData()
            }
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
        cell.title.text = model.alert_title
        cell.date.text = model.alert_startdate
        cell.newLabelView.isHidden = false
        cell.newLabelView.layer.cornerRadius = cell.newLabelView.frame.size.width / 2
        if (model.is_read == "N") {
            cell.newLabelView.isHidden = false
        } else {
            cell.newLabelView.isHidden = true
        }
        cell.layer.cornerRadius = 5
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 80)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = Alerts[Alerts.count - indexPath.item - 1]
        
        //alert click 시 insert 해주는 구문.
        //
        
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
