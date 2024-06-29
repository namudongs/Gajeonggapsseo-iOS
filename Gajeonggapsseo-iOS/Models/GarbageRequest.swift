//
//  GarbageRequest.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import Foundation
import FirebaseFirestore
import MapKit

class Request: Center, Codable {
    var id: UUID
    var type: CenterType
    var address: String
    var latitude: Double
    var longitude: Double
    var garbageType: String //
    var amount: String
    var requestTime: Timestamp
    var preferredPickupTime: Timestamp
    var status: RequestStatus
    var helperId: String?

    init(id: UUID, type: CenterType, address: String, coordinate: CLLocationCoordinate2D, garbageType: String, amount: String, requestTime: Timestamp, preferredPickupTime: Timestamp, status: RequestStatus, helperId: String? = nil) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.garbageType = garbageType
        self.amount = amount
        self.requestTime = requestTime
        self.preferredPickupTime = preferredPickupTime
        self.status = status
        self.helperId = helperId
    }
    
    static let mock: GarbageRequest = GarbageRequest(userId: "",
                                                     address: "제주시 연동 14길 32",
                                                     latitude: 0.0,
                                                     longitude: 0.0,
                                                     garbageType: "플라스틱",
                                                     amount: "1",
                                                     requestTime: Timestamp(date: Date()),
                                                     preferredPickupTime: Timestamp(date: Date()),
                                                     status: .requested)
    
}

enum GarbageType: String {
    case whiteBag = "흰색 종량제 봉투"
    case vinyl = "비닐"
    case canAndScrapMetal = "캔 · 고철"
    case glassBottle = "유리병"
    case styrofoam = "스티로폼"
    case plastic = "플라스틱"
    case clearPETBottle = "투명 페트병"
    case paper = "종이"
}

enum RequestStatus: String, Codable {
    case requested = "requested"
    case accepted = "accepted"
    case pickedUp = "pickedUp"
    case completed = "completed"
    
//    func getStatusContent() -> String {
//            switch self {
//            case .requested:
//                return "Request is pending."
//            case .accepted:
//                return "플라스틱이 수거를 기다리는 중이에요"
//            case .pickedUp:
//                return ""
//            case .completed:
//                return "Request has been completed."
//            }
//        }
}
