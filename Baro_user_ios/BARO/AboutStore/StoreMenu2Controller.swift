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
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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
}
extension StoreMenu2Controller : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView : UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    func collectionView(_ collectionView : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ASMenuCell
        let data : Menu = menus[indexPath.item]
        cell.menu_name.text  = data.menu_name
        cell.menu_description.text  = data.menu_info
        cell.menu_price.text  = String(data.menu_defaultprice)+"원"
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
                    let param = ["storeId":item.store_id,"menu":"\(jsonString)","menuId":"\(menu_id)"] as [String : Any]
                    toOrderDetial(param: param)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 85)
    }
}
