//
//  DataService.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation

// MARK: - API를 불러오는 서비스 클래스
class CleanHouseService: ApiService {
    typealias ResponseType = CleanHouseWelcome
    
    func fetchData(completion: @escaping (Result<CleanHouseWelcome, Error>) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] else { return }
        let baseUrl = "http://apis.data.go.kr/6510000/cleanHouseService/getCleanHouseList"
        guard let url = URL(string: "\(baseUrl)?serviceKey=\(apiKey)&pageNo=1&numOfRows=1374") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(CleanHouseWelcome.self, from: data)
                completion(.success(decodedResponse))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

class RecycleCenterService: ApiService {
    typealias ResponseType = RecycleCenterWelcome
    
    func fetchData(completion: @escaping (Result<RecycleCenterWelcome, Error>) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] else { return }
        let baseUrl = "http://apis.data.go.kr/6510000/recycleCenterService/getRecycleCenterList"
        guard let url = URL(string: "\(baseUrl)?serviceKey=\(apiKey)&pageNo=1&numOfRows=1374") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(RecycleCenterWelcome.self, from: data)
                completion(.success(decodedResponse))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

class SeogwipoCleanHouseService: ApiService {
    typealias ResponseType = [SeogwipoCleanHouse]
    
    func fetchData(completion: @escaping (Result<[SeogwipoCleanHouse], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "SeogwipoCleanHouse", withExtension: "json") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode([SeogwipoCleanHouse].self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(error))
        }
    }
}

class SeogwipoRecycleCenterService: ApiService {
    typealias ResponseType = SeogwipoRecycleCenterApiResponse
    
    func fetchData(completion: @escaping (Result<SeogwipoRecycleCenterApiResponse, Error>) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] else { return }
        let baseUrl = "https://api.odcloud.kr/api/15108248/v1/uddi:55cc390d-ad9c-4398-b793-f1d851a11440"
        guard let url = URL(string: "\(baseUrl)?page=1&perPage=55&serviceKey=\(apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(SeogwipoRecycleCenterApiResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - API 응답을 Center 모델로 매핑
extension CleanHouseWelcome {
    func toCenters() -> [Center] {
        return response.body.items.item.map {
            Center(
                type: .cleanHouse,
                dataCd: $0.dataCd,
                emdNm: $0.emdNm,
                rnAdres: $0.rnAdres,
                laCrdnt: $0.laCrdnt,
                loCrdnt: $0.loCrdnt,
                etcCn: $0.etcCn,
                regDt: $0.regDt,
                pysygClctnbxCnt: $0.pysygClctnbxCnt,
                recycleClctnbxCnt: $0.recycleClctnbxCnt,
                glsbtlClctnbxCnt: $0.glsbtlClctnbxCnt,
                strfClctnbxCnt: $0.strfClctnbxCnt,
                dscdBatteryClctnbxCnt: $0.dscdBatteryClctnbxCnt,
                dscdFlrsclmpClctnbxCnt: $0.dscdFlrsclmpClctnbxCnt,
                fddrnkClctnbxCnt: $0.dscdFlrsclmpClctnbxCnt,
                fddrnkClctnbxMeterCnt: $0.fddrnkClctnbxMeterCnt,
                uumtCn: $0.uumtCn
            )
        }
    }
}

extension RecycleCenterWelcome {
    func toCenters() -> [Center] {
        return response.body.items.item.map {
            Center(
                type: .recycleCenter,
                dataCd: $0.dataCd,
                emdNm: $0.emdNm,
                rnAdres: $0.rnAdres,
                laCrdnt: $0.laCrdnt,
                loCrdnt: $0.loCrdnt,
                etcCn: $0.etcCn,
                regDt: $0.regDt,
                pysygClctnbxCnt: nil,
                recycleClctnbxCnt: nil,
                glsbtlClctnbxCnt: nil,
                strfClctnbxCnt: nil,
                dscdBatteryClctnbxCnt: nil,
                dscdFlrsclmpClctnbxCnt: nil,
                fddrnkClctnbxCnt: nil,
                fddrnkClctnbxMeterCnt: nil,
                uumtCn: $0.operTimeInfo
            )
        }
    }
}

extension SeogwipoCleanHouse {
    static func toCenters(from data: [SeogwipoCleanHouse]) -> [Center] {
        return data.map {
            Center(
                type: .seogwipoCleanHouse,
                dataCd: UUID().uuidString,
                emdNm: $0.읍면동,
                rnAdres: $0.인근주소,
                laCrdnt: String($0.위도),
                loCrdnt: String($0.경도),
                etcCn: nil,
                regDt: nil,
                pysygClctnbxCnt: nil,
                recycleClctnbxCnt: nil,
                glsbtlClctnbxCnt: nil,
                strfClctnbxCnt: nil,
                dscdBatteryClctnbxCnt: nil,
                dscdFlrsclmpClctnbxCnt: nil,
                fddrnkClctnbxCnt: nil,
                fddrnkClctnbxMeterCnt: nil,
                uumtCn: nil
            )
        }
    }
}

extension SeogwipoRecycleCenterApiResponse {
    func toCenters() -> [Center] {
        return data.map {
            Center(
                type: .seogwipoRecycleCenter,
                dataCd: UUID().uuidString,
                emdNm: $0.township,
                rnAdres: $0.address,
                laCrdnt: $0.latitude,
                loCrdnt: $0.longitude,
                etcCn: nil,
                regDt: $0.dataStandardDate,
                pysygClctnbxCnt: nil,
                recycleClctnbxCnt: nil,
                glsbtlClctnbxCnt: nil,
                strfClctnbxCnt: nil,
                dscdBatteryClctnbxCnt: nil,
                dscdFlrsclmpClctnbxCnt: nil,
                fddrnkClctnbxCnt: nil,
                fddrnkClctnbxMeterCnt: nil,
                uumtCn: nil
            )
        }
    }
}
