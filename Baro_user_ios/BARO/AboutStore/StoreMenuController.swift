//
//  StoreMenuController.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/19.
//

import UIKit
private let categoryIdentifier = "ASCategoryCell"
class StoreMenuController : UIViewController{
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
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
    var isFirstViewLoad = false
    @IBOutlet weak var menuPage: UIView!
    private lazy var childController : StoreMenu2Controller? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstViewLoad = true
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
                    self.categoryCollectionView.delegate = self
                    self.categoryCollectionView.dataSource = self
                }
            }
        }
        categoryCollectionView.addSubview(categoryIndecator)
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
        cell.category.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 10.0)
        cell.category.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        self.saveCellsPoint.append(cell.center.x)
        self.saveCelly = cell.center.y
        self.saveIndecatorHeight = ((cell.bounds.height / 2) + 5)
        self.saveIndecatorWidth.append(cell.frame.width)
        if(indexPath.item == 0 && isFirstViewLoad) {
            setCategoryIndecatorAnimation(index: indexPath.row, duration: 0.0)
            let categoryId : Int = categories[indexPath.item].category_id
            var categoryIdMenu = [Menu]()
            for item in self.menus {
                if (item.category_id == categoryId) {
                    categoryIdMenu.append(item)
                }
            }
            actionToSelectedCell(indexPath: indexPath,menus: categoryIdMenu)
            isFirstViewLoad = false
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat((10 * self.categoryNames.count)))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = 0.0
        for index in categoryNames[indexPath.item].utf16 {
            if(index >= 65 && index <= 122) {
                width += 6
            }
            else {
                width += 10
            }
        }
        width += 20
        
        
        return CGSize(width: width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryId : Int = categories[indexPath.item].category_id
        var categoryIdMenu = [Menu]()
        for item in self.menus {
            if (item.category_id == categoryId) {
                categoryIdMenu.append(item)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    @objc func tap(_ sender: Any) {
        let senderG = sender as? UITapGestureRecognizer
        guard let location = senderG?.location(in: self.categoryCollectionView) else { return }
        let indexPath = self.categoryCollectionView.indexPathForItem(at: location)
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
        self.categoryHighlightText.font = UIFont(name: "NotoSansCJKkr-Bold", size: 10.0)
        self.categoryHighlightText.textAlignment = .center
        self.categoryHighlightText.text = "\(self.categoryNames[index])"
        self.categoryHighlightText.translatesAutoresizingMaskIntoConstraints = false
        UIView.animate(withDuration: duration, animations: {
            self.categoryHighlightText.isHidden = true
            self.categoryIndecator.frame = newFrame
            self.categoryHighlightText.frame = newFrame
            self.categoryHighlightText.center.x = self.saveCellsPoint[index]
            self.categoryHighlightText.center.y = self.saveCelly
            self.categoryIndecator.center.x = self.saveCellsPoint[index]
            self.categoryIndecator.center.y = self.saveCelly
        }, completion: { finished in
            self.categoryHighlightText.isHidden = false
            self.categoryHighlightText.topAnchor.constraint(equalTo: self.categoryIndecator.topAnchor).isActive = true
            self.categoryHighlightText.leftAnchor.constraint(equalTo: self.categoryIndecator.leftAnchor).isActive = true
            self.categoryHighlightText.rightAnchor.constraint(equalTo: self.categoryIndecator.rightAnchor).isActive = true
            self.categoryHighlightText.bottomAnchor.constraint(equalTo: self.categoryIndecator.bottomAnchor).isActive = true
        })
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
