//
//  SetNewPW.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/16.
//

import UIKit

class SetNewPW: UIViewController {
    @IBOutlet weak var newPW: UITextField!
    @IBOutlet weak var newPWAgain: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var newPwText: UILabel!
    @IBOutlet weak var newPwAgainText: UILabel!
    let network = CallRequest()
    let urlMaker = NetWorkURL()
    var phoneNumber : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBtn.layer.cornerRadius = 15
        newPW.borderStyle = .none
        newPWAgain.borderStyle = .none
        swipeRecognizer()
    }
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: false, completion: nil)
            default: break
            }
        }
    }
    @IBAction func changePW(_ sender: Any) {
        if newPW.text != newPWAgain.text {
            newPwAgainText.isHidden = false
            return
        }else{
            newPwAgainText.isHidden = true
        }
        var jsonObject = [String : String]()
        jsonObject["phone"] = phoneNumber
        jsonObject["pass"] = newPW.text
        
        network.post(method: .put,param: jsonObject, url: urlMaker.passwordUpdateURL){
            json in
            print(json)
            if json["result"].boolValue {
                let vc = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "FindPWComplete") as! FindPWComplete
//                guard let pvc = self.presentingViewController else { return }
//                self.dismiss(animated: false){
//                    pvc.present(vc, animated: false, completion: nil)
//                }
                guard let pvc = self.presentingViewController else { return }
                self.dismiss(animated: false){
                    pvc.present(vc, animated: false, completion: nil)
                }
            }else{
                print("실패")
            }
        }
        
    }
}
