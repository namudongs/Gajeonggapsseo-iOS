//
//  DataService.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation
import CoreLocation

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
                print("Jeju CleanHouse Decoded Error")
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
                print("Jeju RecycleCenter Decoded Error")
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
            print("Seogwipo CleanHouse Decoded Error")
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
                print("Seogwipo RecycleCenter Decoded Error")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - API 응답을 Center 모델로 매핑
extension CleanHouseWelcome {
    func toCenters() -> [JejuClean] {
        return response.body.items.item.map {
            JejuClean(id: UUID(),
                           type: .cleanHouse,
                           address: $0.rnAdres,
                           coordinate: CLLocationCoordinate2D(latitude: Double($0.laCrdnt) ?? 0, longitude: Double($0.loCrdnt) ?? 0),
                           description: "제주시 클린하우스입니다."
            )
        }
    }
}

extension RecycleCenterWelcome {
    func toCenters() -> [JejuRecycle] {
        return response.body.items.item.map {
            JejuRecycle(id: UUID(),
                        type: .recycleCenter,
                        address: $0.rnAdres,
                        coordinate: CLLocationCoordinate2D(latitude: Double($0.laCrdnt) ?? 0, longitude: Double($0.loCrdnt) ?? 0),
                        description: "제주시 재활용도움센터입니다.")
        }
    }
}

extension SeogwipoCleanHouse {
    static func toCenters(from data: [SeogwipoCleanHouse]) -> [SeogwipoClean] {
        return data.map {
            SeogwipoClean(id: UUID(),
                          type: .seogwipoCleanHouse,
                          address: $0.인근주소,
                          coordinate: CLLocationCoordinate2D(latitude: Double($0.위도), longitude: Double($0.경도)),
                          description: "서귀포시 클린하우스입니다.")
        }
    }
}

extension SeogwipoRecycleCenterApiResponse {
    func toCenters() -> [SeogwipoRecycle] {
        return data.map {
            SeogwipoRecycle(id: UUID(),
                            type: .seogwipoRecycleCenter,
                            address: $0.address,
                            coordinate: CLLocationCoordinate2D(latitude: Double($0.latitude) ?? 0, longitude: Double($0.longitude) ?? 0),
                            description: "서귀포시 재활용도움센터입니다.")
        }
    }
}
