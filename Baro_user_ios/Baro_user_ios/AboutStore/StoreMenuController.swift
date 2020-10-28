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
    
    @IBOutlet weak var containerView: UIView!
    public var netWork : CallRequest!
    public var urlMaker : NetWorkURL!
    public var categories : Dictionary<Int,String>!
    public var array = [String]()
    public var menus = [String : [Menu]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: 60)
        array = Array(categories.values)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.register(ASCategoryCell.self, forCellWithReuseIdentifier: categoryIdentifier)
    }
    func actionToSelectedCell(indexPath : IndexPath,menus : [Menu]){
        setContainerViewController(storyboard: "AboutStore", viewControllerID: "StoreMenu2Controller",index: indexPath.item,menus: menus)
    }
    func setContainerViewController(storyboard: String, viewControllerID: String,index : Int,menus : [Menu]){
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: viewControllerID)
//        let VC = contollers[index]
        (VC as! StoreMenu2Controller).menus = menus
            self.addChild(VC)
            containerView.addSubview((VC.view)!)
            VC.view.frame = containerView.bounds
            VC.didMove(toParent: self)
        }
}

extension StoreMenuController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ASCategoryCell
        cell.category.setTitle(array[indexPath.item], for: .normal)
        cell.category.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ : Int = categories.someKey(forValue: array[indexPath.item])!
        let data : [Menu] = self.menus[array[indexPath.item]]!
        actionToSelectedCell(indexPath: indexPath,menus: data)
    }
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
     
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            let data : [Menu] = self.menus[array[index.item]]!
            actionToSelectedCell(indexPath: index,menus: data)
        }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
