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

class MainPageEvent : UITableViewCell {
    
    var delegateEvent : CellDelegateEvent?
    
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
            for item in json["event"].array! {
                eventModel.event_id = item["event_id"].stringValue
                eventModel.event_image = item["event_image"].stringValue
               
                self.eventList.append(eventModel)
            }
            self.collectionView.reloadData()
        }
        
    }
}

extension MainPageEvent : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = eventList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageEventCell", for: indexPath) as! MainPageEventCell
        cell.eventImage.kf.setImage(with: URL(string: "http://15.165.22.64:8080/ImageEvent.do?image_name=" + event.event_image))
        
        //cell클릭시
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
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
    
}
