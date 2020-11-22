//
//  BasketDialog.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/23.
//

import UIKit
protocol BasketBtnDelegate : AnyObject{
    func tabLeft(index : Int)
    func tabRight(index : Int)
}
class BasketDialog : UIViewController {
    @IBOutlet weak var dialogContentLable: UILabel!
    @IBOutlet weak var deleteBtnView: uiViewSetting!
    @IBOutlet weak var deleteCancelBtnView: uiViewSetting!
    var deleteItemCount : Int = 0
    var deleteItemPos : Int = 0
    var isLastFlag : Bool = false
    var isClickLeft : Bool = false
    var isClickRight : Bool = false
    var currentBasketController = UIViewController()
    
    weak var delegate : BasketBtnDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //deleteBtnView.add
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isLastItemDelet()
    }
    func isLastItemDelet() {
        if(deleteItemCount != 1) {
            dialogContentLable.text = "해당 메뉴를 삭제하시겠습니까?"
        }
        else {
            isLastFlag = true
        }
    }
    @objc func clickLeftView() {
        isClickLeft = true
        
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func clickLeft() {
        isClickLeft = true
        delegate?.tabLeft(index : deleteItemPos)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickRight() {
        isClickRight = true
        delegate?.tabRight(index : deleteItemPos)
        self.dismiss(animated: false, completion: nil)
    }
}
