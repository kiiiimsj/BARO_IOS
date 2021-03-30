//
//  BeforeRegister.swift
//  Baro_user_ios
//
//  Created by . on 2021/01/05.
//

import UIKit

class BeforeRegister: UIViewController {
    private var canGo = false
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var radioEntire: UIButton!
    @IBOutlet weak var radio1: UIButton!
    @IBOutlet weak var radio2: UIButton!
    @IBOutlet weak var radio3: UIButton!
    @IBOutlet weak var radio4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor.white
    }
    
    @IBAction func pressRadio1(_ sender: Any) {
        let value = !radio1.isSelected
        radio1.isSelected = value
        check()
    }
    @IBAction func pressRadio2(_ sender: Any) {
        let value = !radio2.isSelected
        radio2.isSelected = value
        check()
    }
    @IBAction func pressRadio3(_ sender: Any) {
        let value = !radio3.isSelected
        radio3.isSelected = value
        check()
    }
    @IBAction func pressRadio4(_ sender: Any) {
        let value = !radio4.isSelected
        radio4.isSelected = value
        check()
    }
    @IBAction func pressRadioEntire(_ sender: Any) {
        let value = !radioEntire.isSelected
        radio1.isSelected = value
        radio2.isSelected = value
        radio3.isSelected = value
        radio4.isSelected = value
        radioEntire.isSelected = value
        check()
    }
    func check() {
        if radio1.isSelected && radio2.isSelected && radio3.isSelected {
            if radio4.isSelected {
                radioEntire.isSelected = true
            }else{
                radioEntire.isSelected = false
            }
            nextBtn.backgroundColor = UIColor.baro_main_color
            canGo = true
        }else{
            radioEntire.isSelected = false
            nextBtn.backgroundColor = UIColor.lightGray
            canGo = false
        }
    }
    @IBAction func pressNextBtn(_ sender: Any) {
        if !canGo {
            return
        }
        let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "PhoneSendForRegister") as! PhoneSendForRegister
        vc.marketing = radio4.isSelected
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = . crossDissolve
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: false){
            pvc.present(vc, animated: false, completion: nil)
        }
        
    }
    @IBAction func pressArrow1(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Terms", bundle: nil).instantiateViewController(withIdentifier: "TermOfUser") as! TermOfUser
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = . crossDissolve
        vc.type = TermOfUser.TERMS
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func pressArrow2(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Terms", bundle: nil).instantiateViewController(withIdentifier: "TermOfUser") as! TermOfUser
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = . crossDissolve
        vc.type = TermOfUser.PRIVACY
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressArrow3(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Terms", bundle: nil).instantiateViewController(withIdentifier: "TermOfUser") as! TermOfUser
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = . crossDissolve
        vc.type = TermOfUser.LOCATION
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func pressBackBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
