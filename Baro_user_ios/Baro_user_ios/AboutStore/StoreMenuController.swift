//
//  StoreMenuController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//

import UIKit
private let categoryIdentifier = "ASCategoryCell"
class StoreMenuController : UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var categoryHighlightText: UILabel!
    @IBOutlet weak var categoryIndecator: uiViewSetting!
    var netWork = CallRequest()
    var urlMaker = NetWorkURL()
    public var categories = [categoryModel]()
    public var categoryNames = [String]()
    public var menus = [Menu]()
    public var store_id = ""
    public var saveCellsPoint = [CGFloat]()
    public var saveCelly = CGFloat()
    public var saveIndecatorWidth = [CGFloat]()
    public var saveIndecatorHeight = CGFloat()
    private var initiateComplete = false
    
    @IBOutlet weak var menuPage: UIView!
    private lazy var childController : StoreMenu2Controller? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        
        collectionView.addSubview(categoryIndecator)
        netWork.get(method: .get, url: urlMaker.categoryURL + "?store_id="+store_id) {
            (json) in
            if json["result"].boolValue{
                for item in json["category"].array!{
                    self.categoryNames.append(item["category_name"].stringValue)
                    var category = categoryModel()
                    category.category_id = item["category_id"].intValue
                    category.category_name = item["category_name"].stringValue
                    self.categories.append(category)
                }
                self.netWork.get(method: .get, url: self.urlMaker.menuURL + "?store_id="+self.store_id) { (json) in
                    let boolValue = json["result"].boolValue
                    if boolValue {
                        self.collectionView.delegate = self
                        self.collectionView.dataSource = self
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
                        }
                    }
                }
            }
        }
    }
    func actionToSelectedCell(indexPath : IndexPath,menus : [Menu]){
        setContainerViewController(storyboard: "AboutStore", viewControllerID: "StoreMenu2Controller",index: indexPath.item,menus: menus)
    }
    func setContainerViewController(storyboard: String, viewControllerID: String,index : Int,menus : [Menu]){
        
        if !initiateComplete {
            let storyboard = UIStoryboard(name: storyboard, bundle: nil)
            childController = storyboard.instantiateViewController(withIdentifier: viewControllerID) as? StoreMenu2Controller
            (childController!).menus = menus
            self.addChild(childController!)
            menuPage.addSubview((childController!.view)!)
            childController!.view.frame = menuPage.bounds
            childController!.didMove(toParent: self)
            initiateComplete = true
        }else{
            childController?.menus = menus
            childController?.collectionView.reloadData()
        }
        
    }
}

extension StoreMenuController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ASCategoryCell
        
        cell.category.setTitle(categoryNames[indexPath.item], for: .normal)
        cell.category.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15.0)
        cell.category.titleLabel?.textAlignment = .center
        cell.category.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        self.saveIndecatorHeight = ((cell.bounds.height / 2) + 5)
        self.saveIndecatorWidth.append(CGFloat(categoryNames[indexPath.item].count) * 20)
        self.saveCellsPoint.append(cell.center.x - (self.saveIndecatorWidth[indexPath.item]/2))
        self.saveCelly = -self.saveIndecatorHeight - 5
                
        if(indexPath.row == 0) {
            setCategoryIndecatorAnimation(index: indexPath.row, duration: 0.0)
            let categoryId : Int = categories[indexPath.item].category_id
            var categoryIdMenu = [Menu]()
            for item in self.menus {
                if (item.category_id == categoryId) {
                    categoryIdMenu.append(item)
                }
            }
            actionToSelectedCell(indexPath: indexPath,menus: categoryIdMenu)
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryId : Int = categories[indexPath.item].category_id
        var categoryIdMenu = [Menu]()
        for item in self.menus {
            if (item.category_id == categoryId) {
                categoryIdMenu.append(item)
            }
        }
        //actionToSelectedCell(indexPath: indexPath,menus: categoryIdMenu)
    }
    @objc func tap(_ sender: Any) {
        let senderG = sender as? UITapGestureRecognizer
        guard let location = senderG?.location(in: self.collectionView) else { return }
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            setCategoryIndecatorAnimation(index: index.row, duration: 0.2)
            var categoryIdMenu = [Menu]()
            for item in self.menus {
                if (item.category_id == categories[index.item].category_id) {
                    categoryIdMenu.append(item)
                }
            }
            actionToSelectedCell(indexPath: index,menus: categoryIdMenu)
            
        }
    }
    func setCategoryIndecatorAnimation(index : Int, duration : Double) {
        self.categoryHighlightText.isHidden = true
        var newFrame = self.categoryIndecator.frame
        newFrame.size.width = self.saveIndecatorWidth[index]
        newFrame.size.height = self.saveIndecatorHeight
        self.categoryIndecator.frame = newFrame
        self.categoryHighlightText.frame = newFrame
        self.categoryHighlightText.textAlignment = .center
        self.categoryHighlightText.translatesAutoresizingMaskIntoConstraints = false
        self.categoryHighlightText.text = self.categoryNames[index]
        UIView.animate(withDuration: duration, animations: {
            self.categoryHighlightText.isHidden = true
            self.categoryIndecator.transform = CGAffineTransform(translationX: self.saveCellsPoint[index], y:  self.saveCelly )
        }, completion: { finished in
            self.categoryHighlightText.isHidden = false
        })
        self.categoryHighlightText.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.categoryHighlightText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.categoryHighlightText.centerXAnchor.constraint(equalTo: self.categoryIndecator.centerXAnchor).isActive = true
        self.categoryHighlightText.centerYAnchor.constraint(equalTo: self.categoryIndecator.centerYAnchor).isActive = true
    }
}
class categoryModel {
    var category_id = 0
    var category_name = ""
}
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
