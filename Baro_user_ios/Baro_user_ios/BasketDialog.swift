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
        deleteBtnView.isUserInteractionEnabled = true
        deleteCancelBtnView.isUserInteractionEnabled = true
        
        deleteBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickLeftView(_:))))
        deleteCancelBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickRightView(_:))))
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
    @objc func clickLeftView(_ sender : UIButton) {
        isClickLeft = true
        
        self.dismiss(animated: false) {
            self.delegate?.tabLeft(index : self.deleteItemPos)
        }
    }
    @objc func clickRightView(_ sender : UIButton) {
        isClickRight = true
        self.dismiss(animated: false) {
            self.delegate?.tabRight(index : self.deleteItemPos)
        }
    }
    @IBAction func clickLeft() {
        isClickLeft = true
        
        self.dismiss(animated: false) {
            self.delegate?.tabLeft(index : self.deleteItemPos)
        }
    }
    
    @IBAction func clickRight() {
        isClickRight = true
        self.dismiss(animated: false) {
            self.delegate?.tabRight(index : self.deleteItemPos)
        }
    }
}
