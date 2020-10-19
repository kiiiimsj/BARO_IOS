//
//  AboutStore.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//


import UIKit
private let FirstBarIdentifier = "ASFirstBarCell"
class AboutStore : UIViewController {

    @IBOutlet weak var FirstPage: UICollectionView!
    @IBOutlet weak var FirstBar: UICollectionView!
    
    private let netWork = CallRequest()
    private let urlMaker = NetWorkURL()
    private var menus = [Menu]()
    private var categories = Dictionary<Int,String>()
    public var union = [String : [Menu]]()
    public var first = ["메뉴 정보","가게 정보"]
    private var storeInfoManager = StoreInfoController()
    private var storeMenuManager = StoreMenuController()
    private var contollers = [UIViewController]()
    public override func viewDidLoad() {
        super.viewDidLoad()
        storeInfoManager.netWork = netWork
        storeInfoManager.urlMaker = urlMaker
        contollers.append(storeInfoManager)
        contollers.append(storeMenuManager)
        netWork.get(method: .get, url: urlMaker.categoryURL + "?store_id=1") { (json) in
            if json["result"].boolValue{
                for item in json["category"].array!{
                    self.categories[item["category_id"].intValue] = item["category_name"].stringValue
                    self.union[item["category_name"].stringValue] = [Menu]();
                }
                self.netWork.get(method: .get, url: self.urlMaker.menuURL + "?store_id=1") { (json) in
                    let boolValue = json["result"].boolValue
                    if boolValue {
                        var tempMenu = Menu()
                        let jsonObject = json["menu"].array!
                        for item in jsonObject {
                            tempMenu.menu_defaultprice = item["menu_defaultprice"].intValue
                            tempMenu.menu_id = item["menu_id"].intValue
                            tempMenu.category_id = item["category_id"].intValue
                            tempMenu.menu_image = item["menu_image"].stringValue
                            tempMenu.store_id = item["store_id"].intValue
                            tempMenu.menu_name = item["menu_name"].stringValue
                            tempMenu.menu_info = item["menu_info"].stringValue
                            tempMenu.is_soldout = item["is_soldout"].stringValue
                            self.menus.append(tempMenu)
                            self.union[self.categories[tempMenu.category_id]!]?.append(tempMenu)
                        }
                        self.FirstBar.delegate = self
                        self.FirstBar.dataSource = self
                        self.FirstBar.reloadData()
                    }else{
                        
                        
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(index)")
        actionToSelectedCell(indexPath: indexPath)
    }
    func actionToSelectedCell(indexPath : IndexPath){
        setContainerViewController(index: indexPath.row)
        }
    func setContainerViewController(index : Int){
        let VC = contollers[index]
        print("\(index)")
            self.addChild(VC)
            FirstPage.addSubview((VC.view)!)
            VC.view.frame = FirstPage.bounds
            VC.didMove(toParent: self)
        }
}

extension AboutStore : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return first.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FirstBar.dequeueReusableCell(withReuseIdentifier: FirstBarIdentifier,for: indexPath) as! ASFirstStoreCell
        cell.state.setTitle(first[indexPath.row], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / CGFloat(first.count)*0.97),height: FirstBar.frame.height)
    }
}
