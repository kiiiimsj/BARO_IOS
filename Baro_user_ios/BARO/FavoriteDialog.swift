//
//  FavoriteDialog.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/11/02.
//

import UIKit
class FavoriteDialog : UIViewController {
    @IBOutlet weak var favoriteDialogTitle: UILabel!
    @IBOutlet weak var dialogContent: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    public var isFlag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setDialogLabel(index: isFlag)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func setDialogLabel(index : Int) {
        if (self.isFlag == 1) {
            self.favoriteDialogTitle.text = "즐겨찾기 삭제"
            self.dialogContent.text = "즐겨찾기에서 삭제 되었습니다."
        }
        else {
            self.favoriteDialogTitle.text = "즐겨찾기 추가"
            self.dialogContent.text = "즐겨찾기에 추가 되었습니다."
        }
    }
    @IBAction func okayButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
