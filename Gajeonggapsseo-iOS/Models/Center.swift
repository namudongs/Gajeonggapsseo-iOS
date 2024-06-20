//
//  Center.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation
import MapKit

class Center: Identifiable {
    let id = UUID()
    let type: CenterType
    let dataCd: String
    let emdNm: String
    let rnAdres: String
    var laCrdnt: String?
    var loCrdnt: String?
    let etcCn: String?
    let regDt: String?
    
    var coordinate: CLLocationCoordinate2D? {
        guard let laCrdnt = laCrdnt, let loCrdnt = loCrdnt,
              let latitude = Double(laCrdnt), let longitude = Double(loCrdnt) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(type: CenterType, dataCd: String, emdNm: String, rnAdres: String, laCrdnt: String? = nil, loCrdnt: String? = nil, etcCn: String?, regDt: String?) {
        self.type = type
        self.dataCd = dataCd
        self.emdNm = emdNm
        self.rnAdres = rnAdres
        self.laCrdnt = laCrdnt
        self.loCrdnt = loCrdnt
        self.etcCn = etcCn
        self.regDt = regDt
    }
}

enum CenterType: String {
    case cleanHouse = "제주시 클린하우스"
    case recycleCenter = "제주시 재활용도움센터"
    case seogwipoCleanHouse = "서귀포시 클린하우스"
    case seogwipoRecycleCenter = "서귀포시 재활용도움센터"
}
