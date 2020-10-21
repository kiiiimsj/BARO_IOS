//
//  MainPageController.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/18.
//

import UIKit

class MainPageController: UIViewController {
    
    
    //table list
    @IBOutlet weak var tableViewEvent: UITableView!
    
    @IBOutlet weak var tableViewType: UITableView!
    
    @IBOutlet weak var tableViewUltra: UITableView!
    
    @IBOutlet weak var tableViewNewStore: UITableView!
    
    
    //blur view
    @IBOutlet var blurView: UIVisualEffectView!
    
    //alert이미지 - 아래에서 off/on체크해주기
    @IBOutlet weak var alertButton: UIButton!
    
    //alert 클릭시
    @IBAction func alertClick(_ sender: Any) {
        //alert페이지로 넘기기
    }
    
    
    //search 버튼 클릭시
    @IBAction func searchButton(_ sender: Any) {
        animateIn(desiredView: blurView)
        animateIn(desiredView: searchPopupView)
    }
    
    @IBAction func searchCompleteButton(_ sender: Any) {
        //검색한 가게리스트로 넘어가기
    }
    
    //취소버튼도 하나 만들기
    
    
    //search팝업뷰
    @IBOutlet var searchPopupView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewEvent.separatorStyle = .none
        tableViewType.separatorStyle = .none
        tableViewUltra.separatorStyle = .none
        tableViewNewStore.separatorStyle = .none
        
        blurView.bounds = self.view.bounds
        searchPopupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        
    }
    
    //search바 클릭했을때 배경 애니메이션
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
        
        
    }
    
}

extension MainPageController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableViewEvent){
            let cell = tableViewEvent.dequeueReusableCell(withIdentifier: "MainPageEvent", for: indexPath)
            return cell
        }
        else if(tableView == tableViewType){
            let cell = tableViewType.dequeueReusableCell(withIdentifier: "MainPageType", for: indexPath)
            
            return cell
        }
        else if(tableView == tableViewUltra){
            let cell = tableViewUltra.dequeueReusableCell(withIdentifier: "MainPageUltraStore", for: indexPath)
            return cell
        }
        else {
            let cell = tableViewNewStore.dequeueReusableCell(withIdentifier: "MainPageNewStore", for: indexPath)
            return cell
        }
        
    }
    
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
    

}
