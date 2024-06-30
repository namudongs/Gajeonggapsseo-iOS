//
//  DataLoader.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation

class DataLoader {
    static let shared = DataLoader()
    private init() { }
    
    func loadData(for centerType: CenterType, completion: @escaping (Result<[any Center], Error>) -> Void) {
        switch centerType {
        case .cleanHouse:
            let service = CleanHouseService()
            service.fetchData { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toCenters()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .recycleCenter:
            let service = RecycleCenterService()
            service.fetchData { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toCenters()))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        case .seogwipoCleanHouse:
            let service = SeogwipoCleanHouseService()
            service.fetchData { result in
                switch result {
                case .success(let response):
                    completion(.success(SeogwipoCleanHouse.toCenters(from: response)))
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        case .seogwipoRecycleCenter:
            let service = SeogwipoRecycleCenterService()
            service.fetchData { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toCenters()))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        case .garbageRequest, .requestInProgress:
            break
        }
    }
    
    func loadAllData(completion: @escaping (Result<[any Center], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var allCenters: [any Center] = []
        var fetchError: Error?
        
        dispatchGroup.enter()
        loadData(for: .cleanHouse) { result in
            switch result {
            case .success(let centers):
                allCenters.append(contentsOf: centers)
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        loadData(for: .recycleCenter) { result in
            switch result {
            case .success(let centers):
                allCenters.append(contentsOf: centers)
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        loadData(for: .seogwipoCleanHouse) { result in
            switch result {
            case .success(let centers):
                allCenters.append(contentsOf: centers)
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        loadData(for: .seogwipoRecycleCenter) { result in
            switch result {
            case .success(let centers):
                allCenters.append(contentsOf: centers)
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(allCenters))
            }
        }
    }
}
