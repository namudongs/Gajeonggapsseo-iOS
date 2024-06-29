//
//  Center.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import Foundation
import MapKit

protocol Center: Identifiable {
    var id: UUID { get }
    var type: CenterType { get }
    var address: String { get set }
    var coordinate: CLLocationCoordinate2D { get set }
}

class JejuClean: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    init(id: UUID, type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
    }
}

class JejuRecycle: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    init(id: UUID, type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
    }
}

class SeogwipoClean: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    init(id: UUID, type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
    }
}

class SeogwipoRecycle: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    init(id: UUID, type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
    }
}

enum CenterType: String, Codable {
    case cleanHouse = "제주시 클린하우스"
    case recycleCenter = "제주시 재활용도움센터"
    case seogwipoCleanHouse = "서귀포시 클린하우스"
    case seogwipoRecycleCenter = "서귀포시 재활용도움센터"
    case garbageRequest = "배출 요청"
}
