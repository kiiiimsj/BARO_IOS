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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBar = segue.destination as? BottomTabBarController else { return }
        tabBar.indexValue = 1
    }
    func loadUrl() {
        //let url = URL(fileURLWithPath: "/policy")
        //webView.loadFileURL(url, allowingReadAccessTo: url)
        
        let url = Bundle.main.url(forResource: "privacyPolicy", withExtension:"html")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
    }
    
}
