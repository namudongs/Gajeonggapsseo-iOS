//
//  LocationManager.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/19/24.
//

import Foundation
import MapKit

// MARK: - 지도에서 필요한 위치 정보를 관리하는 매니저
class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var centers: [any Center] = []
    var manager: CLLocationManager = .init()
    
    
    override init() {
        super.init()
        
        self.configureLocationManager()
    }
    
    // MARK: - 사용자의 위치 권한 여부를 확인하고 요청하거나 현재 위치 MapView를 이동하는 메서드
    func configureLocationManager() {
        manager.delegate = self
        
        let status = manager.authorizationStatus
        
        if status == .notDetermined {
            manager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.currentLocation = manager.location
        }
    }
    
    // MARK: - 사용자의 위치가 변경되면 호출되는 메서드
    /// startUpdatingLocation 메서드 또는 requestLocation 메서드를 호출했을 때에만 이 메서드가 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("[SUCCESS] Did Update Locations")
        if let location = locations.last {
            self.currentLocation = location
        }
    }
    
    // MARK: - 사용자의 현재 위치를 가져오는 것을 실패했을 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: - 도로명 주소를 좌표로 변환해주는 메서드
    func getCoordinateFrom(address: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
            } else if let placemarks = placemarks, let placemark = placemarks.first {
                let location = placemark.location
                completion(location?.coordinate, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    // MARK: - 파라미터로 받은 위치와 가장 가까운 센터를 반환해주는 메서드
    func findNearestCenter(from requestLocation: CLLocationCoordinate2D) -> (String, String, String)? {
        guard !centers.isEmpty else { return nil }
        
        var centerName = ""
        var centerAddress = ""
        var centerDistance = ""
        
        
        let nearestCenter = centers.min {
            let request = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
            guard $0.coordinate.latitude < 40 else { return false }
            
            let location1 = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            let location2 = CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude)
            
            let location1Distance = request.distance(from: location1)
            let location2Distance = request.distance(from: location2)
            
            return location1Distance < location2Distance
        }
        
        let requestCenterCL = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        let nearestCenterCL = CLLocation(latitude: nearestCenter?.coordinate.latitude ?? 0, longitude: nearestCenter?.coordinate.longitude ?? 0)
        centerDistance = requestCenterCL.distance(from: nearestCenterCL).formattedDistance()
        
        switch nearestCenter {
        case let jejuClean as JejuClean:
            centerName = "\(jejuClean.description) 클린하우스"
            centerAddress = jejuClean.address.replacingOccurrences(of: "제주특별자치도", with: "")
        case let jejuRecycle as JejuRecycle:
            centerName = "제주시 재활용도움센터\(jejuRecycle.dataCode)"
            centerAddress = jejuRecycle.address.replacingOccurrences(of: "제주특별자치도", with: "")
        case let seogwipoClean as SeogwipoClean:
            centerName = "\(seogwipoClean.description) 클린하우스"
            centerAddress = seogwipoClean.address.replacingOccurrences(of: "제주특별자치도", with: "")
        case let seogwipoRecycle as SeogwipoRecycle:
            centerName = "\(seogwipoRecycle.townName) 재활용도움센터"
            centerAddress = seogwipoRecycle.address.replacingOccurrences(of: "제주특별자치도", with: "")
        default:
            return nil
        }
        
        return (centerName, centerAddress, centerDistance)
    }
    
    // MARK: - 위치 권한 요청
    func requestLocation() {
        manager.startUpdatingLocation()
    }
    
    // MARK: - 길찾기
    func openDirections(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, for name: String) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            guard (response?.routes.first) != nil else { return }
            
            let mapItem = MKMapItem(placemark: destinationPlacemark)
            mapItem.name = name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
