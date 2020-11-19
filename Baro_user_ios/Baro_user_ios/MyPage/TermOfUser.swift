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
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUrl()
    }
    
    @IBAction func backbutton() {
        self.performSegue(withIdentifier: "BottomTabBarController", sender: nil)
    }
    func loadUrl() {
        let url = Bundle.main.url(forResource: "privacyPolicy", withExtension:"html")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
    }
    
}
