//
//  TermOfUser.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/26.
//

import UIKit
import WebKit
import Kingfisher

class TermOfUser : UIViewController{
    public static let LOCATION = "location_information"
    public static let PRIVACY = "privacy_statement"
    public static let TERMS = "terms_of_service"
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    public var type : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUrl()
    }
    
    @IBAction func backbutton() {
        self.dismiss(animated: true)
    }
    func loadUrl() {
        switch type {
        case TermOfUser.LOCATION:
            let url = Bundle.main.url(forResource: "location_information", withExtension:"html")
            let request = URLRequest(url: url!)
            webView.load(request)
            break
        case TermOfUser.PRIVACY:
            let url = Bundle.main.url(forResource: "privacy_statement", withExtension:"html")
            let request = URLRequest(url: url!)
            webView.load(request)
        case TermOfUser.TERMS:
            let url = Bundle.main.url(forResource: "terms_of_service", withExtension:"html")
            let request = URLRequest(url: url!)
            webView.load(request)
        default:
            let url = Bundle.main.url(forResource: "privacy_statement", withExtension:"html")
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        backBtn.setImage(UIImage(named: "arrow_left"), for: .normal)
    }
    
}
