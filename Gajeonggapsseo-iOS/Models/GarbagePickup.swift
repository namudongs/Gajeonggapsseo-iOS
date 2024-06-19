//
//  GarbagePickup.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import Foundation
import FirebaseFirestore

struct GarbagePickup: Identifiable, Codable {
    @DocumentID var id: String?
    var requestId: String
    var helperId: String
    var pickupStartTime: Timestamp
    var pickupEndTime: Timestamp?
    var status: PickupStatus // "진행중", "완료됨"
    var pickupPhotoUrl: String?
    var completionPhotoUrl: String?
}

enum PickupStatus: Codable {
    case inProgress
    case completed
}
