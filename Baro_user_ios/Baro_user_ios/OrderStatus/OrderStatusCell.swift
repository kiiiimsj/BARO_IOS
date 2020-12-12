//
//  OrderStatusCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/28.
//

import UIKit

protocol statusDelegate  {
    func callStore(vc : UIViewController)
    func showDetails(vc : OrderStatusDetailController)
}
class OrderStatusCell : UICollectionViewCell {
    public static var ACCEPT = "ACCEPT"
    public static var PREPARING = "PREPARING"
    
    public var delegate : statusDelegate!
    public var orderInfo : OrderStatusList!
    @IBOutlet weak var orderStoreNameLabel: UILabel!

    @IBOutlet weak var orderStoreImage: UIImageView!

    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
   
    
    @IBOutlet weak var progressBarShell: UIView!
    
    @IBOutlet weak var orderCompleteImage: UIImageView!
    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var firstText: UILabel!
    @IBOutlet weak var acceptingImage: UIImageView!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var secondText: UILabel!
    @IBOutlet weak var makingImage: UIImageView!
    @IBOutlet weak var thirdLine: UIView!
    @IBOutlet weak var thirdText: UILabel!
    @IBOutlet weak var doneImage: UIImageView!
    
    @IBOutlet weak var callStoreBtn: UIButton!
    
    @IBOutlet weak var showDetailBtn: UIButton!
    var statuses : [Status]!
    
//    override func prepareForReuse() {
//        orderStoreImage.image = nil
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        setupViews()
    }
    
//    func setupViews() {
//        self.progressBarShell.addSubview(verticalProgress)
//        
//        verticalProgress.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        verticalProgress.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        verticalProgress.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        verticalProgress.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        
//    }
    func makeStatus(state : String){
        statuses = [Status]()
        let temp1 = Status(image: orderCompleteImage, line: firstLine, text: firstText)
        statuses.append(temp1)
        let temp2 = Status(image: acceptingImage, line: secondLine, text: secondText)
        statuses.append(temp2)
        let temp3 = Status(image: makingImage, line: thirdLine, text: thirdText)
        statuses.append(temp3)
        getStatus(state: state)
        buttonSetting()

    }
    func buttonSetting(){
        callStoreBtn.layer.borderWidth = 1
        callStoreBtn.layer.borderColor = UIColor.baro_main_color.cgColor
        callStoreBtn.layer.cornerRadius = 5
        showDetailBtn.layer.borderWidth = 1
        showDetailBtn.layer.borderColor = UIColor.baro_main_color.cgColor
        showDetailBtn.layer.cornerRadius = 5
        
    }
    func changeColor(number : Int) {
        for i in 0..<number {
            statuses[i].changeOnColor();
            statuses[i].changeOffTextColor()
        }
        for i in number..<3 {
            statuses[i].changeOffColor()
        }
        statuses[number].changeOnTextColor()
        
        
    }
    func getStatus(state : String){
        switch state {
        case OrderStatusCell.PREPARING:
            changeColor(number: 1)
        case OrderStatusCell.ACCEPT:
            changeColor(number: 2)
        default:
            changeColor(number: 3)
        }
    }
    
    public class Status {
        var image : UIImageView!
        var line : UIView!
        var text : UILabel!
        init(image : UIImageView, line : UIView, text : UILabel) {
            self.image = image
            self.line = line
            self.text = text
        }
        func changeOnTextColor() {
            text.textColor = .black
        }
        func changeOnColor() {
            image.image = UIImage(named: "on-1")
            line.backgroundColor = .baro_main_color
            
        }
        func changeOffTextColor() {
            text.textColor = .lightGray
        }
        func changeOffColor() {
            image.image = UIImage(named: "off-1")
            line.backgroundColor = .systemGray
        }
        
        

    }
    @IBAction func showDetail(_ sender: Any) {
        let vc = UIStoryboard(name: "OrderStatus", bundle: nil).instantiateViewController(identifier: "OrderStatusDetailController") as! OrderStatusDetailController
        
        vc.receipt_id = orderInfo.receipt_id
        vc.order_count = orderInfo.total_count
        vc.store_name = orderInfo.store_name
        vc.total_price = orderInfo.total_price
        
        delegate.showDetails(vc: vc)
    }
 
    @IBAction func callStore(_ sender: Any) {
        
        delegate.callStore(vc: UIViewController())
    }
}
