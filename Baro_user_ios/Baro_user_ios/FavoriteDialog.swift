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
        if (UserDefaults.standard.value(forKey: "isFlag") != nil) {
            self.isFlag = UserDefaults.standard.value(forKey: "isFlag") as! Int
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLabelBorder()
        setDialogLabel(index: isFlag)
        print("isFlag : ", isFlag)
    }
    func setDialogLabel(index : Int) {
        if (self.isFlag == 1) {
            self.favoriteDialogTitle.text = "즐겨찾기 추가"
            self.dialogContent.text = "즐겨찾기에 추가 되었습니다."
        }
        else {
            self.favoriteDialogTitle.text = "즐겨찾기 삭제"
            self.dialogContent.text = "즐겨찾기에서 삭제 되었습니다."
        }
    }
    func setLabelBorder() {
        checkBtn.layer.borderWidth = 1.0
        checkBtn.layer.cornerRadius = 5.0
        checkBtn.layer.borderColor = UIColor(red: 131/255, green: 51/255, blue: 230/255, alpha: 1).cgColor
    }
    @IBAction func okayButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
