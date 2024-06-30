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
    var description: String { get set }
}

class JejuClean: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    var localAddress: String
    var regularBinCount: Int
    var recycleBinCount: Int
    var glassBinCount: Int
    var styrofoamBinCount: Int
    var batteryBinCount: Int
    var fluorescentBinCount: Int
    var foodWasteBinCount: Int
    var foodWasteMeterBinCount: Int
    var cctvCount: Int
    var specialNote: String
    var hasPhoto: Bool
    var otherInfo: String
    var registrationDate: Date
    var photo: String?
    var dataCode: String
    var districtName: String
    var townName: String
    var complexName: String
    var typeName: String
    
    init(id: UUID = UUID(), type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String, localAddress: String, regularBinCount: Int, recycleBinCount: Int, glassBinCount: Int, styrofoamBinCount: Int, batteryBinCount: Int, fluorescentBinCount: Int, foodWasteBinCount: Int, foodWasteMeterBinCount: Int, cctvCount: Int, specialNote: String, hasPhoto: Bool, otherInfo: String, registrationDate: Date, photo: String? = nil, dataCode: String, districtName: String, townName: String, complexName: String, typeName: String) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
        self.localAddress = localAddress
        self.regularBinCount = regularBinCount
        self.recycleBinCount = recycleBinCount
        self.glassBinCount = glassBinCount
        self.styrofoamBinCount = styrofoamBinCount
        self.batteryBinCount = batteryBinCount
        self.fluorescentBinCount = fluorescentBinCount
        self.foodWasteBinCount = foodWasteBinCount
        self.foodWasteMeterBinCount = foodWasteMeterBinCount
        self.cctvCount = cctvCount
        self.specialNote = specialNote
        self.hasPhoto = hasPhoto
        self.otherInfo = otherInfo
        self.registrationDate = registrationDate
        self.photo = photo
        self.dataCode = dataCode
        self.districtName = districtName
        self.townName = townName
        self.complexName = complexName
        self.typeName = typeName
    }
}

class JejuRecycle: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    var dataCode: String
    var townName: String
    var operatingHours: String
    var installationDate: Date
    var otherInfo: String
    var registrationDate: Date
    
    init(id: UUID = UUID(), type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String, dataCode: String, townName: String, operatingHours: String, installationDate: Date, otherInfo: String, registrationDate: Date) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
        self.dataCode = dataCode
        self.townName = townName
        self.operatingHours = operatingHours
        self.installationDate = installationDate
        self.otherInfo = otherInfo
        self.registrationDate = registrationDate
    }
}

class SeogwipoClean: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    var townName: String
    var location: String
    var nearbyAddress: String
    var dataStandardDate: Date
    
    init(id: UUID = UUID(), type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String, townName: String, location: String, nearbyAddress: String, dataStandardDate: Date) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
        self.townName = townName
        self.location = location
        self.nearbyAddress = nearbyAddress
        self.dataStandardDate = dataStandardDate
    }
    
    static let mock = SeogwipoClean(id: UUID(),
                                    type: .seogwipoCleanHouse,
                                    address: "",
                                    coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                    description: "",
                                    townName: "",
                                    location: "",
                                    nearbyAddress: "",
                                    dataStandardDate: Date())
}

class SeogwipoRecycle: Center {
    var id = UUID()
    var type: CenterType
    var address: String
    var coordinate: CLLocationCoordinate2D
    var description: String
    
    var townName: String
    var name: String
    var operationStartTime: String
    var operationEndTime: String
    var operationStartDate: Date
    var bottleRefundAvailable: Bool
    var smallApplianceDisposalFree: Bool
    var cookingOilDisposalFree: Bool
    var pesticideSafeDisposal: Bool
    var icePackReuse: Bool
    var batteryPaperCanPetCompensation: Bool
    var dataStandardDate: Date
    
    init(id: UUID = UUID(), type: CenterType, address: String, coordinate: CLLocationCoordinate2D, description: String, townName: String, name: String, operationStartTime: String, operationEndTime: String, operationStartDate: Date, bottleRefundAvailable: Bool, smallApplianceDisposalFree: Bool, cookingOilDisposalFree: Bool, pesticideSafeDisposal: Bool, icePackReuse: Bool, batteryPaperCanPetCompensation: Bool, dataStandardDate: Date) {
        self.id = id
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.description = description
        self.townName = townName
        self.name = name
        self.operationStartTime = operationStartTime
        self.operationEndTime = operationEndTime
        self.operationStartDate = operationStartDate
        self.bottleRefundAvailable = bottleRefundAvailable
        self.smallApplianceDisposalFree = smallApplianceDisposalFree
        self.cookingOilDisposalFree = cookingOilDisposalFree
        self.pesticideSafeDisposal = pesticideSafeDisposal
        self.icePackReuse = icePackReuse
        self.batteryPaperCanPetCompensation = batteryPaperCanPetCompensation
        self.dataStandardDate = dataStandardDate
    }
}

enum CenterType: String, Codable {
    case cleanHouse = "제주시 클린하우스"
    case recycleCenter = "제주시 재활용도움센터"
    case seogwipoCleanHouse = "서귀포시 클린하우스"
    case seogwipoRecycleCenter = "서귀포시 재활용도움센터"
    case garbageRequest = "배출 요청"
    case requestInProgress = "배출 대행 중"
}
