//
//  CLLocationDistance+Extension.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 7/2/24.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    func formattedDistance() -> String {
        if self < 1000 {
            return String(format: "%.0f m", self)
        } else {
            let kilometers = self / 1000
            return String(format: "%.1f km", kilometers)
        }
    }
}
