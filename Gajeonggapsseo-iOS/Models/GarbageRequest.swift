//
//  GarbageRequest.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import Foundation
import FirebaseFirestore

struct GarbageRequest: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var address: String
    var latitude: Double
    var longitude: Double
    var garbageType: String
    var amount: String
    var requestTime: Timestamp
    var preferredPickupTime: Timestamp
    var status: RequestStatus // "요청됨", "수락됨", "완료됨"
}

enum RequestStatus: Codable {
    case requested
    case accepted
    case completed
}
