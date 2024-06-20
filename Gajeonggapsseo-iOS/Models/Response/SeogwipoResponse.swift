//
//  SeogwipoResponse.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation

// SeogwipoCleanHouse 모델
struct SeogwipoCleanHouse: Codable {
    let 읍면동: String
    let 위치: String
    let 인근주소: String
    let 데이터기준일자: String
    let 위도: Double
    let 경도: Double
}

// SeogwipoRecycleCenter 모델
struct SeogwipoRecycleCenter: Codable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let longitude: String
    let latitude: String
    let address: String
    let township: String
    let startTime: String
    let endTime: String
    let operationStartDate: String
    let oilFreeDisposal: String
    let bottleRefund: String
    let smallApplianceFreeDisposal: String
    let icePackReuse: String
    let batteryCanCompensation: String
    let pesticideSafeDisposal: String
    let dataStandardDate: String

    enum CodingKeys: String, CodingKey {
        case name = "명칭"
        case longitude = "경도"
        case latitude = "위도"
        case address = "주소"
        case township = "읍면동"
        case startTime = "운영시작시간"
        case endTime = "운영종료시간"
        case operationStartDate = "운영개시일"
        case oilFreeDisposal = "가정용 폐식용유 무상배출"
        case bottleRefund = "빈병 보증금 환불제"
        case smallApplianceFreeDisposal = "소형 폐가전 무상배출"
        case icePackReuse = "아이스팩 재사용"
        case batteryCanCompensation = "폐건전지 종이팩(컵) 캔류·투명페트 보상"
        case pesticideSafeDisposal = "폐농약(원액) 안심처리"
        case dataStandardDate = "데이터기준일자"
    }
}

// SeogwipoRecycleCenterApiResponse 모델
struct SeogwipoRecycleCenterApiResponse: Codable {
    let currentCount: Int
    let data: [SeogwipoRecycleCenter]
    let matchCount: Int
    let page: Int
    let perPage: Int
    let totalCount: Int
}
