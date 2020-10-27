//
//  ASCategoryCell.swift
//  Baro_user_ios
//
//  Created by . on 2020/10/20.
//

import UIKit
class ASCategoryCell : UICollectionViewCell{
    
    @IBOutlet var category: UIButton!
//    public var title : UIButton = {
//        let btn = UIButton()
//        return btn
//    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(title)
//        title.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
//        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
//        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
//        title.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // 초기화 할 코드 예시
        category.backgroundColor = .blue
        category.titleLabel?.text = nil
    }
}
