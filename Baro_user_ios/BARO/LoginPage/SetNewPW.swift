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
    public var restoreFrameValue : CGFloat = 0.0
    public var up = false
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
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func changePW(_ sender: Any) {
        let pass = newPW.text
        let passNSString = pass! as NSString
        var passGetResult : NSTextCheckingResult?
        
        let passRegex = try? NSRegularExpression(pattern: "^(?=.*[0-9]+)[a-zA-Z][a-zA-Z0-9]{7,}$", options: .caseInsensitive)
        passGetResult = passRegex?.firstMatch(in: pass!, options: [], range: NSRange(location: 0, length: passNSString.length))
        let result = passGetResult?.numberOfRanges as? Int
        if(result == nil) {
            newPwText.isHidden = false
            newPwText.text = "영어와 숫자 조합으로 8글자 이상 입력해주세요."
        }
        else {
            newPwText.isHidden = true
            if newPW.text != newPWAgain.text {
                newPwAgainText.isHidden = false
                return
            }else{
                newPwAgainText.isHidden = true
            }
        }
       
        var jsonObject = [String : String]()
        jsonObject["phone"] = phoneNumber
        jsonObject["pass"] = newPW.text
        if(!newPwAgainText.isHidden || !newPwText.isHidden) {
            return
        }
        network.post(method: .put,param: jsonObject, url: urlMaker.passwordUpdateURL){
            json in
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.frame.origin.y = restoreFrameValue
        self.view.endEditing(true)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        self.view.frame.origin.y = self.restoreFrameValue
//        return true
//    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField.isEqual(newPW) || textField.isEqual(newPWAgain) {
//            up = true
//        }else{
//            up = false
//        }
//        return true
//    }
}
