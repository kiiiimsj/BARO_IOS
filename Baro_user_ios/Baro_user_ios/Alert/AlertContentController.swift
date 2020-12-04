//
//  AlertContentController.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/12/04.
//

import UIKit
class AlertContentController : UIViewController {
    var Alert = AlertModel()
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertDate: UILabel!
    @IBOutlet weak var alertContent: UILabel!
    @IBOutlet weak var alertContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ALERT :! ", Alert)
        alertTitle.text = "\(Alert.alert_title)"
        alertDate.text = "\(Alert.alert_startdate)"
        //alertContent.text = "\(Alert.alert_content)"
        alertContent.text = "-학원과 스터디카페도 밤 9시 이후 운영 중단\n" +
        "-대중 교통, 오후 9시 이후 30% 감축 운영\n" +
        "-박물관 등 공공문화시설, 청소년 시설 운영 중단\n" +
        "-사회 복지 시설은 돌봄 유지위해 일부만 운영\n" +
        "-기독교 등 종교계에 비대면집회 전환 요청\n" +
        "-출근 시간 유동인구 분산 위해 서울시, 자치구, 투자출연기관은 재택근무 및 시차 출퇴근제 권고\n" +
        "-민간 부문도 절반 재택근무 권고\n\n" +
         
        "신종 코로나바이러스 감염증(코로나19) 확진자가 급증하고 있는 서울시가 방역 조치를 강화했다. 5일부터 오후 9시 이후 서울 시내 독서실과 마트, 스터디카페, 영화관, PC방 등은 문을 닫아야 한다.\n" +
         
        "서정협 서울시장 권한대행은 4일 오후 온라인 긴급브리핑을 통해 이 같은 방역 강화 조치를 오는 18일까지 2주간 시행한다고 밝혔다. 이에 따라 오후 9시 이후에는 영화관과 PC방, 오락실, 독서실, 스터디카페, 놀이공원, 이·미용원, 마트, 백화점 등 일반 관리시설도 모두 문을 닫아야 한다.\n" +
         
        "다만 서울시는 필수적인 생필품을 구입할 수 있도록 300㎡ 미만의 소규모 편의점 운영과 음식점의 포장·배달을 허용했다.\n" +
         
        "독서실과 교습소, 입시학원 2036곳을 포함해 총 2만5천 곳의 학원, 독서실, 스터디카페도 오후 9시 이후 운영을 중단해야 한다. 시는 학원 등의 오후 9시 이전 수업도 온라인 전환을 강력히 권고키로 했다.\n" +
         
        "시는 아울러 대중교통의 야간운행 30% 감축도 오후 9시로 1시간 앞당겨 시행키로 했다. 시내버스는 5일부터, 지하철은 8일부터 오후 9시 이후 30% 감축 운행된다.\n"
            +
        "이밖에도 서울시는 시와 자치구, 시 투자출연기관이 운영하는 박물관, 미술관, 공연장, 도서관 등 공공문화시설 66개소, 청소년시설 114개소, 공공체육시설 1114개소 등 공공이용시설은 시간과 관계없이 일체의 운영을 전면 중단하기로 했다.\n"
            +
        "종교계에도 비대면으로 종교 활동을 할 것을 강력하게 권고했다. 서 권한대행은 \"이미 동참해주신 불교, 원불교, 천도교, 성균관에 감사드리며 기독교와 천주교의 비대면 온라인 예배 전환을 간곡하게 요청한다\"고 말했다."
    }
}
