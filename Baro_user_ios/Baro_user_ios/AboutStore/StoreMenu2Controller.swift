//
//  StoreMenu2Controller.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/20.
//

import UIKit

private let cellIdentifier = "ASMenuCell"
class StoreMenu2Controller : UIViewController{
    public var menus = [Menu]()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        print("twice?")
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
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menus[indexPath.item].is_soldout == "Y" {
            return
        }
        let menu_id = String(menus[indexPath.item].menu_id)
        //navigationController?.pushViewController(OrderDetailsController(), animated: false)
        performSegue(withIdentifier: "toDetails", sender: menu_id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? OrderDetailsController else {
            return
        }
        let labell = sender as! String
        nextViewController.menu_id = labell
        for item in self.menus {
            if(item.menu_id == Int(labell)) {
                nextViewController.menu = item
            }
        }
    }
}
