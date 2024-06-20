//
//  JejuResponse.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation

/// CleanHouseApiResponse 모델
struct CleanHouseWelcome: Codable {
    let response: CleanHouseApiResponse
}

struct CleanHouseApiResponse: Codable {
    struct Header: Codable {
        let resultCode: String
        let resultMsg: String
    }
    
    struct Body: Codable {
        struct Items: Codable {
            struct Item: Codable {
                let lnmAdres: String
                let laCrdnt: String
                let loCrdnt: String
                let pysygClctnbxCnt: String
                let recycleClctnbxCnt: String
                let glsbtlClctnbxCnt: String
                let strfClctnbxCnt: String
                let dscdBatteryClctnbxCnt: String
                let dscdFlrsclmpClctnbxCnt: String
                let fddrnkClctnbxCnt: String
                let fddrnkClctnbxMeterCnt: String
                let cctvInstlCnt: String
                let uumtCn: String
                let photoYn: String
                let etcCn: String
                let regDt: String
                let photo: [String?]
                let dataCd: String
                let seNm: String
                let emdNm: String
                let hsmpNm: String
                let pttnNm: String
                let rnAdres: String
            }
            let item: [Item]
        }
        let items: Items
        let pageNo: Int
        let totalCount: Int
        let numOfRows: Int
    }
    let header: Header
    let body: Body
}

/// RecycleCenterApiResponse 모델
struct RecycleCenterWelcome: Codable {
    let response: RecycleCenterApiResponse
}

struct RecycleCenterApiResponse: Codable {
    struct Header: Codable {
        let resultCode: String
        let resultMsg: String
    }

    struct Body: Codable {
        struct Items: Codable {
            struct Item: Codable {
                let dataCd: String
                let emdNm: String
                let rnAdres: String
                let operTimeInfo: String
                let instlYmd: String
                let laCrdnt: String
                let loCrdnt: String
                let etcCn: String
                let regDt: String
            }
            let item: [Item]
        }
        let items: Items
        let pageNo: Int
        let totalCount: Int
        let numOfRows: Int
    }
    let header: Header
    let body: Body
}
