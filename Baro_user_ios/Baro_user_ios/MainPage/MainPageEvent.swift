//
//  MainPageEventCell.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/19.
//

import UIKit

protocol CellDelegateEvent: class {
    func tapClickEvent(tag: String)
}

class MainPageEvent : UICollectionViewCell {
    var rightSwipe : UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        swipe.addTarget(self, action: #selector(swipe(recognizer:)))
        return swipe
    }
    var leftSwipe : UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .left
        swipe.addTarget(self, action: #selector(swipe(recognizer:)))
        return swipe
    }
    var delegateEvent : CellDelegateEvent?
    var a = 0
    var indexPaths = [IndexPath]()
    var eventList = [EventListModel]()
    let networkModel = CallRequest()
    let networkURL = NetWorkURL()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        

        networkModel.post(method: .get, url: networkURL.eventList) { json in
            var eventModel = EventListModel()
            print("jj",json)
            for item in json["event"].array! {
                eventModel.event_id = item["event_id"].stringValue
                eventModel.event_image = item["event_image"].stringValue
               
                self.eventList.append(eventModel)
            }
            self.collectionView.reloadData()
//            DispatchQueue.global().async {
//
//                while true {
//                    Thread.sleep(forTimeInterval: 5)
//                    print("zzz",self.a)
//
//                    DispatchQueue.main.sync {
//                        self.collectionView.scrollToItem(at: self.indexPaths[self.a], at: .right, animated: true)
//                        self.a += 1
//                    }
//                    if self.a >= self.eventList.count {
//                        self.a = 0
//                    }
//                }
//            }
        }
        
    }

}

extension MainPageEvent : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("tt",eventList.count)
        return eventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = eventList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageEventCell", for: indexPath) as! MainPageEventCell
        cell.eventImage.kf.setImage(with: URL(string: "http://3.35.180.57:8080/ImageEvent.do?image_name=" + event.event_image))
        cell.backgroundColor = .purple
        //cell클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        if indexPath.item == 0 {
            cell.addGestureRecognizer(rightSwipe)
            cell.eventImage.addGestureRecognizer(rightSwipe)
        }else if indexPath.item == eventList.count - 1 {
            cell.addGestureRecognizer(leftSwipe)
            cell.eventImage.addGestureRecognizer(leftSwipe)
        }
        
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let eventId = eventList[indexPath!.row].event_id
        if let index = indexPath {
            print("eventtap!! index : \(eventId)")
            delegateEvent?.tapClickEvent(tag: eventId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 200)
    }
    @objc func swipe(recognizer : UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .right:
            print("rightDirection",eventList.count - 1)
            self.collectionView.scrollToItem(at: IndexPath(item: eventList.count-1, section: 0) , at: .right, animated: true)
        case .left:
            print("leftDirection")
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
        default:
            print("?????")
        }
    }
    @objc func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is right")
//        self.collectionView.scrollToItem(at: self.indexPaths[eventList.count-1], at: .right, animated: true)
    }
    @objc func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is left")
    }
}

