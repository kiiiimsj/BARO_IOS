//
//  Notice.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/25.
//

import UIKit
class NoticePageController : UIViewController {
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    @IBOutlet weak var noticeListTableView : UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var noticeList = [NoticeListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setImage(UIImage(named: "arrow_back"), for: .normal)
        loadNoticePageTitle()
        
        noticeListTableView.delegate = self
        noticeListTableView.dataSource = self
    }
    @IBAction func backbutton() {
        self.performSegue(withIdentifier: "BottomTabBarController", sender: nil)
    }
    
    func loadNoticePageTitle() {
        networkModel.post(method: .get, param: nil, url: networkURL.noticeAll) { json in
            var notice = NoticeListModel()
            print(json)
            if json["result"].boolValue {
                for item in json["notice"].array! {
                    notice.title = item["title"].stringValue
                    notice.notice_code = item["notice_code"].stringValue
                    notice.notice_date = item["notice_date"].stringValue
                    notice.content = item["content"].stringValue
                    self.noticeList.append(notice)
                }
            }
            self.noticeListTableView.reloadData()
        }
    }
}
extension NoticePageController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("bb", noticeList.count)
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notice = noticeList[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        
        cell.noticeTitle.text = notice.title
        cell.noticeContent.text = notice.content
        cell.noticeDate.text = notice.notice_date

        return cell
    }
}
