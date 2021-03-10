//
//  StoreMenu2Controller.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/20.
//

import UIKit

private let cellIdentifier = "ASMenuCell"
class StoreMenu2Controller : UIViewController {
    public var menus = [Menu]()
    let bottomTabBarInfo = BottomTabBarController()
    @IBOutlet weak var discount_alarm: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var alarmImage: UIImageView!
    @IBOutlet weak var discount_alarm_label: CustomLabel!
    public var discount_rate  : Int = 0 {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
                discount_alarm_label.text = "\(discount_rate)%"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        createAlarmShpae()
        alarmImage.tintColor = UIColor.baro_main_color
        alarmImage.image = UIImage(named: "timer_white")?.withRenderingMode(.alwaysTemplate)
    }
    func toOrderDetial(param : [String:Any]) {
        let storyboard = UIStoryboard(name: "BottomTabBar", bundle: nil)
        let ViewInBottomTabBar = storyboard.instantiateViewController(withIdentifier: "BottomTabBarController") as! BottomTabBarController
        ViewInBottomTabBar.controllerIdentifier = bottomTabBarInfo.orderDetailControllerIdentifier
        ViewInBottomTabBar.controllerStoryboard = bottomTabBarInfo.orderDetailStoryBoard
        ViewInBottomTabBar.controllerSender = param
        ViewInBottomTabBar.moveFromOutSide = true
        
        ViewInBottomTabBar.modalPresentationStyle = .fullScreen
        ViewInBottomTabBar.modalTransitionStyle = .crossDissolve
        self.present(ViewInBottomTabBar, animated: true, completion: nil)
    }
    func createAlarmShpae(){
        discount_alarm.layer.cornerRadius = 10
        discount_alarm.layer.borderWidth = 0.5
        discount_alarm.layer.borderColor = UIColor.baro_main_color.cgColor
        discount_alarm_label.text = "\(discount_rate)%"
    }
}
extension StoreMenu2Controller : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView : UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    func collectionView(_ collectionView : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ASMenuCell
        let data : Menu = menus[indexPath.item]
        cell.menu_name.text  = data.menu_name
        cell.menu_description.text  = data.menu_info
        cell.menu_price.text  = String(data.menu_defaultprice)+"원"
        cell.menu_price.attributedText = cell.menu_price.text?.strikeThrough()
        cell.realPrice.text = String(data.menu_defaultprice * (100-discount_rate)/100)+"원"
//        cell.menu_price.text  = String(Int(Float(data.menu_defaultprice) * (Float(100-discount_rate))/100))+"원"
        cell.menu_state.text = "품절"
        cell.menu_picture.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageMenu.do?store_id="+String(data.store_id)+"&image_name="+String(data.menu_image)))
        if data.is_soldout == "N" {
            cell.menu_state.isHidden = true
        }else{
            cell.menu_state.isHidden = false
            cell.menu_state.layer.borderWidth = 2
            cell.menu_state.layer.borderColor = UIColor.white.cgColor
            cell.menu_state.layer.cornerRadius = 5
            cell.menu_state.layer.masksToBounds = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menus[indexPath.item].is_soldout == "Y" {
            return
        }
        let menu_id = String(menus[indexPath.item].menu_id)
        for item in self.menus {
            if(item.menu_id == Int(menu_id)) {
                let encoder = JSONEncoder()
                let jsonSaveData = try? encoder.encode(item)
                if let _ = jsonSaveData, let jsonString = String(data: jsonSaveData!, encoding: .utf8) {
                    let param = ["storeId":item.store_id,"menu":"\(jsonString)","menuId":"\(menu_id)","discount_rate" : discount_rate] as [String : Any]
                    toOrderDetial(param: param)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 85)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("draggggggg","start")
        discount_alarm.isHidden = true
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("draggggggg","end")
        discount_alarm.isHidden = false
    }
}
