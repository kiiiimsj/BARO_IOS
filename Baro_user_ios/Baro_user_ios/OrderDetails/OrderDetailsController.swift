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
    public var menu_default_price = 0
    public var menu_price_current = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        menu_price_current = menu_default_price
        menu_count.text = "1"
        recalcPrice()
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
    @IBAction func AddCount(_ sender: Any) {
        menu_count.text = String(Int(menu_count.text!)! + 1)
        recalcPrice()
    }
    @IBAction func AbstractCount(_ sender: Any) {
        print("minus")
        if Int(menu_count.text!) == 1{
            return
        }
        menu_count.text = String(Int(menu_count.text!)! - 1)
        recalcPrice()
    }
    func recalcPrice(){
        menu_price.text = String(Int(menu_count.text!)! * menu_price_current)+"원"
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
            cell.clickListener = self
            cell.iPath = indexPath
            cell.optionCategory.text = extras?[0].extra_group
            if cell.extras.count > 3 {
                cell.whichCell = EssentialCell.OVER3
            }else{
                cell.whichCell = EssentialCell.UNDER3
            }
            return cell
        case 1:
            let cell = EssentialArea.dequeueReusableCell(withReuseIdentifier: "NonEssentialCell", for: indexPath) as! NonEssentialCell
            return cell

        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let extras = essentials[categories[indexPath.item]]
        guard extras == nil else {
            switch extras?.count {
            case 0,1,2,3:
                return CGSize(width: collectionView.frame.width ,height: 120)
            default:
                return CGSize(width: collectionView.frame.width, height: CGFloat(70 + extras!.count * 50))
            }
        }
        return CGSize()
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
    func radioClick(extra_name: String, extraPrice: Int) {
        menu_price_current += extraPrice
        recalcPrice()
    }
    
    func click(extra_name: String, extraPrice: Int, iPath : IndexPath) {
        menu_price_current += extraPrice
        menu_price.text = String(Int(menu_count.text!)! * menu_price_current)+"원"
    }
    
}
struct Notice{
    let date: String
    let title: String
    let content: String
    var open = false
    mutating func dateFormat() ->
    String{ guard let s = self.date.split(separator: " ").first
    else {
            return "??"
    }
        return String(s)
    }
}
