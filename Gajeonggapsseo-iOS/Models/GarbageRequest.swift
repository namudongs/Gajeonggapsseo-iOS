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
    var status: RequestStatus // "요청됨", "수락됨", "픽업됨", "완료됨"
    var helperId: String? // 수락한 경우 수락한 사람의 ID 입력
}

enum RequestStatus: String, Codable {
    case requested = "requested"
    case accepted = "accepted"
    case pickuped = "pickuped"
    case completed = "completed"
}
