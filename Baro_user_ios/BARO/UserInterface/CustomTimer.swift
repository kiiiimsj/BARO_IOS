//
//  CustomTimer.swift
//  BARO
//
//  Created by . on 2021/02/09.
//

import Foundation

class CustomTimer {
    static let RELOAD_TIME = "00:00"
    static let myTimer = DispatchQueue(label: "myTimer")
    var a = 0
    let mformatter = DateFormatter()
    let sformatter = DateFormatter()
    let fixedTime =  DateComponents(year: 1970, month: 1, day: 1, hour: 0,minute: 15,second: 0)
    var fixedDate : Date?
    static private var timersTime = "-"
    init() {
        fixedDate = Calendar.current.date(from: fixedTime)
         // 특정 포맷으로 날짜를 보여주기 위한 변수 선언
        mformatter.dateFormat = "mm" // 날짜 포맷 지정
        sformatter.dateFormat = "ss" // 날짜 포맷 지정
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updatetime), userInfo: nil, repeats: true)
    }
    @objc func updatetime() {
        let min = Int(mformatter.string(from: Date()))! % 15
        let sec = Int(sformatter.string(from: Date()))!
        var realSec = 0
        var realMin = 0
        if sec == 0 {
//            print(String(14-min+1)+":"+String(0))
            realMin = 14-min+1
//            CustomTimer.timersTime = String(14-min+1)+":"+String(0)
        }else{
//            print(String(14-min)+":"+String(60-sec))
//            CustomTimer.timersTime = String(14-min)+":"+String(60-sec)
            realMin = 14-min
            realSec = 60 - sec
        }
        var timeString =  ""
        if realMin < 10 {
            timeString += ("0" + String(realMin))
        }else{
            timeString += (String(realMin))
        }
        timeString += ":"
        if realSec < 10 {
            timeString += ("0" + String(realSec))
        }else{
            timeString += (String(realSec))
        }
        CustomTimer.timersTime = timeString
        print(timeString)
    }
    public static func getTime() -> String {
        return CustomTimer.timersTime
    }
    

}
