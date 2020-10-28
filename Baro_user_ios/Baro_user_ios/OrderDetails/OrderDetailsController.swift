//
//  OrderDetailsController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/26.
//

import UIKit

class OrderDetailsController : UIViewController {
    @IBOutlet weak var menu_image: UIImageView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_price: UILabel!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var plus: UIButton!
    private var network = CallRequest()
    private var urlMaker = NetWorkURL()
    private var essentials = [String : [Extra]]()
    private var nonEssentials = [Extra]()
    private var categories = [String]()
    @IBOutlet weak var EssentialArea: UICollectionView!
    public var menu_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        network.get(method: .get, url: urlMaker.extra+"?menu_id="+menu_id) {(json) in
            if json["result"].boolValue{
                for item in json["extra"].array!{
                    var temp = Extra()
                    temp.extra_maxcount = item["extra_maxcount"].intValue
                    temp.extra_name = item["extra_name"].stringValue
                    temp.extra_price = item["extra_price"].intValue
                    temp.extra_id = item["extra_id"].intValue
                    temp.extra_group = item["extra_group"].stringValue
                    if temp.extra_group == "null"{
                        self.nonEssentials.append(temp)
                    }else{
                        if self.essentials[temp.extra_group] == nil{
                            self.essentials[temp.extra_group] = [Extra]()
                            self.categories.append(temp.extra_group)
                        }
                        self.essentials[temp.extra_group]?.append(temp)
                    }
                }
                self.EssentialArea.delegate = self
                self.EssentialArea.dataSource = self
                self.EssentialArea.reloadData()
            }
        }
    }
}

extension OrderDetailsController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("kkkk",section)
        switch section {
        case 0:
            return essentials.count
        case 1:
            return nonEssentials.count
        default:
            return 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("kkkk",indexPath.section)
        switch indexPath.section {
        case 0:
            let extras = essentials[categories[indexPath.item]]
            let cell = EssentialArea.dequeueReusableCell(withReuseIdentifier: "EssentialCell", for: indexPath) as! EssentialCell
            cell.extras = extras!
            cell.collection.delegate = cell.self
            cell.collection.dataSource = cell.self
            return cell
        case 1:
            let cell = EssentialArea.dequeueReusableCell(withReuseIdentifier: "NonEssentialCell", for: indexPath) as! NonEssentialCell
            return cell

        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width ,height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OptionsHeader", for: indexPath) as! OptionsHeader

        switch indexPath.section {
        case 0:
            headerview.header.text = "필수 옵션"
        case 1:
            headerview.header.text = "퍼스널 옵션"
        default:
            return headerview
        }
        return headerview
      }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension OrderDetailsController : CellDelegateExtra{
    func click(extra_name: String, extraPrice: Int) {
        print("qqqq",String(extraPrice)+"ddddDDd" + extra_name)
    }
    
    
}
