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
    var deleteItemCount : Int = 0
    var deleteItemPos : Int = 0
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteCancelBtn: UIButton!
    var isLastFlag : Bool = false
    var isClickLeft : Bool = false
    var isClickRight : Bool = false
    
    weak var delegate : BasketBtnDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteBtn.isUserInteractionEnabled = true
        deleteCancelBtn.isUserInteractionEnabled = true
        deleteBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickLeftView(_:))))
        deleteCancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickRightView(_:))))
        
        let dialogButtonForm = DialogForm()
        dialogButtonForm.setLeftButton(left: deleteCancelBtn)
        dialogButtonForm.setRightbutton(right: deleteBtn)
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
