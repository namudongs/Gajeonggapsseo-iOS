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
    var description: String
    
    var id: UUID
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var garbageType: String
    var amount: String
    var requestTime: Timestamp
    var preferredPickupTime: Timestamp
    var status: RequestStatus
    var helperId: String?

    init(id: UUID, type: CenterType, address: String, coordinate: CLLocationCoordinate2D, garbageType: String, amount: String, requestTime: Timestamp, preferredPickupTime: Timestamp, status: RequestStatus, helperId: String? = nil, description: String) {
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
        self.description = description
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case address
        case latitude
        case longitude
        case garbageType
        case amount
        case requestTime
        case preferredPickupTime
        case status
        case helperId
        case description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(CenterType.self, forKey: .type)
        self.address = try container.decode(String.self, forKey: .address)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.garbageType = try container.decode(String.self, forKey: .garbageType)
        self.amount = try container.decode(String.self, forKey: .amount)
        
        let requestTimeDouble = try container.decode(Double.self, forKey: .requestTime)
        self.requestTime = Timestamp(seconds: Int64(requestTimeDouble), nanoseconds: 0)
        
        let preferredPickupTimeDouble = try container.decode(Double.self, forKey: .preferredPickupTime)
        self.preferredPickupTime = Timestamp(seconds: Int64(preferredPickupTimeDouble), nanoseconds: 0)
        
        self.status = try container.decode(RequestStatus.self, forKey: .status)
        self.helperId = try container.decodeIfPresent(String.self, forKey: .helperId)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(address, forKey: .address)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(garbageType, forKey: .garbageType)
        try container.encode(amount, forKey: .amount)
        try container.encode(requestTime.seconds, forKey: .requestTime)
        try container.encode(preferredPickupTime.seconds, forKey: .preferredPickupTime)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(helperId, forKey: .helperId)
    }
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
}
