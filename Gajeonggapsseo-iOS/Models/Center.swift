//
//  Center.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation
import MapKit

protocol Center: Identifiable {
    var id: UUID { get }
    var type: CenterType { get }
    var address: String { get set }
    var latitute: String? { get set }
    var longtitute: String? { get set }
    var coordinate: CLLocationCoordinate2D? { get set }
}

class JejuCleanHouse: Center {
    let id = UUID()
    let type: CenterType
    var address: String
    var latitute: String?
    var longtitute: String?
    var coordinate: CLLocationCoordinate2D? {
        guard let laCrdnt = latitute, let loCrdnt = longtitute,
              let latitude = Double(laCrdnt), let longitude = Double(loCrdnt) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(type: CenterType, address: String, latitute: String, longtitute: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.type = type
        self.address = address
        self.latitute = latitute
        self.longtitute = longtitute
        self.coordinate = coordinate
    }
}

enum CenterType: String {
    case cleanHouse = "제주시 클린하우스"
    case recycleCenter = "제주시 재활용도움센터"
    case seogwipoCleanHouse = "서귀포시 클린하우스"
    case seogwipoRecycleCenter = "서귀포시 재활용도움센터"
}

//class Center: Identifiable {
//    let id = UUID()
//    let type: CenterType
//    let dataCd: String
//    let emdNm: String
//    let rnAdres: String // 도로명주소
//    var laCrdnt: String? // 위도
//    var loCrdnt: String? // 경도
//    let etcCn: String? // 기타 내용
//    let regDt: String? // 등록 일시
//    let pysygClctnbxCnt: String? // 종량제 수거함 수
//    let recycleClctnbxCnt: String? // 재활용 수거함 수
//    let glsbtlClctnbxCnt: String? // 유리병 수거함 수
//    let strfClctnbxCnt: String? // 스티로폼 수거함 수
//    let dscdBatteryClctnbxCnt: String? // 폐건전지 수거함 수
//    let dscdFlrsclmpClctnbxCnt: String? // 폐형광등 수거함 수
//    let fddrnkClctnbxCnt: String? // 음식물 수거함 수
//    let fddrnkClctnbxMeterCnt: String? // 음식물 계량 수거함 수
//    let uumtCn: String? // 특이사항 내용
//    
//    var coordinate: CLLocationCoordinate2D? {
//        guard let laCrdnt = laCrdnt, let loCrdnt = loCrdnt,
//              let latitude = Double(laCrdnt), let longitude = Double(loCrdnt) else {
//            return nil
//        }
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//    
//    init(type: CenterType, dataCd: String, emdNm: String, rnAdres: String, laCrdnt: String? = nil, loCrdnt: String? = nil, etcCn: String?, regDt: String?, pysygClctnbxCnt: String?, recycleClctnbxCnt: String?, glsbtlClctnbxCnt: String?, strfClctnbxCnt: String?, dscdBatteryClctnbxCnt: String?, dscdFlrsclmpClctnbxCnt: String?, fddrnkClctnbxCnt: String?, fddrnkClctnbxMeterCnt: String?, uumtCn: String?) {
//        self.type = type
//        self.dataCd = dataCd
//        self.emdNm = emdNm
//        self.rnAdres = rnAdres
//        self.laCrdnt = laCrdnt
//        self.loCrdnt = loCrdnt
//        self.etcCn = etcCn
//        self.regDt = regDt
//        self.pysygClctnbxCnt = pysygClctnbxCnt
//        self.recycleClctnbxCnt = recycleClctnbxCnt
//        self.glsbtlClctnbxCnt = glsbtlClctnbxCnt
//        self.strfClctnbxCnt = strfClctnbxCnt
//        self.dscdBatteryClctnbxCnt = dscdBatteryClctnbxCnt
//        self.dscdFlrsclmpClctnbxCnt = dscdFlrsclmpClctnbxCnt
//        self.fddrnkClctnbxCnt = fddrnkClctnbxCnt
//        self.fddrnkClctnbxMeterCnt = fddrnkClctnbxMeterCnt
//        self.uumtCn = uumtCn
//    }
//}
