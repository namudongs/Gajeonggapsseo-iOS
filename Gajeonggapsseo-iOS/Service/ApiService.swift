//
//  ApiService.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation

protocol ApiService {
    associatedtype ResponseType: Codable
    func fetchData(completion: @escaping (Result<ResponseType, Error>) -> Void)
}
