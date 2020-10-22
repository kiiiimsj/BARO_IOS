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
    
    public var netWork : CallRequest!
    public var urlMaker : NetWorkURL!
    public var categories : Dictionary<Int,String>!
    public var array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 5, height: 40)
        array = Array(categories.values)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.register(ASCategoryCell.self, forCellWithReuseIdentifier: categoryIdentifier)
    }
}

extension StoreMenuController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ASCategoryCell
        print("zzz",array[indexPath.item])
        cell.category.setTitle(array[indexPath.item], for: .normal)
        cell.backgroundColor = .darkGray
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 5, height: 40)
    }
    
}
