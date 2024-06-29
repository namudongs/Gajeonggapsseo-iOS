//
//  MapViewRepresentable.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var centers: [any Center]
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCenter: (any Center)?
    @Binding var sheetPresent: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKPointAnnotation.self))
        
        context.coordinator.checkLocationAuthorization()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.annotations.isEmpty {
            let annotations = centers.compactMap { center -> CustomAnnotation in
                CustomAnnotation(title: center.address, coordinate: center.coordinate, type: center.type)
            }
            uiView.addAnnotations(annotations)
        } else {
            
        }
        
        if !sheetPresent {
            uiView.selectedAnnotations.forEach { annotation in
                uiView.deselectAnnotation(annotation, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func ImageFromCenterType(_ type: CenterType) -> (String, CGSize, CGRect) {
        switch type {
        case .cleanHouse, .seogwipoCleanHouse:
            return ("LightblueMapPin", CGSize(width: 32, height: 40), CGRect(x: 0, y: 0, width: 32, height: 40))
        case .recycleCenter, .seogwipoRecycleCenter:
            return ("BlueMapPin", CGSize(width: 32, height: 40), CGRect(x: 0, y: 0, width: 32, height: 40))
        case .garbageRequest:
            return ("PurpleMapPin", CGSize(width: 38, height: 39), CGRect(x: 0, y: 0, width: 38, height: 39))
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapViewRepresentable
        var locationManager = CLLocationManager()
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }
        
        func checkLocationAuthorization() {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            parent.region = region
            locationManager.stopUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
            
            let identifier = "CustomAnnotation"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if view == nil {
                view = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            } else {
                view?.annotation = customAnnotation
            }
            
            view?.canShowCallout = false
            view?.isEnabled = true
            
            let pinConfig = parent.ImageFromCenterType(customAnnotation.type)
            
            if let pinImage = UIImage(named: pinConfig.0) {
                let size = pinConfig.1
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                pinImage.draw(in: CGRect(origin: .zero, size: size))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                view?.image = resizedImage
            }
            
            view?.frame = pinConfig.2
            view?.centerOffset = CGPoint(x: 0, y: -view!.frame.size.height / 2)
            view?.isUserInteractionEnabled = true
            
            return view
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let customAnnotation = view.annotation as? CustomAnnotation {
                if let center = parent.centers.first(where: { $0.address == customAnnotation.title }) {
                    parent.selectedCenter = center
                    parent.sheetPresent = true
                }
                let originalAnnotationSize = view.frame.size
                
                UIView.animate(withDuration: 0.3) {
                    view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    view.zPriority = .max
                }
                
                mapView.setCenter(customAnnotation.coordinate, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            UIView.animate(withDuration: 0.3) {
                view.transform = .identity
                view.zPriority = .defaultUnselected
            }
            
            parent.sheetPresent = false
        }
        
        // MARK: - 제주도 밖으로 지도가 이동하지 않게 하는 메소드
//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            let jejuCenter = CLLocationCoordinate2D(latitude: 33.3628, longitude: 126.5334)
//            let jejuRegionRadius: CLLocationDistance = 75000
//            let jejuRegion = MKCoordinateRegion(center: jejuCenter, latitudinalMeters: jejuRegionRadius * 2, longitudinalMeters: jejuRegionRadius * 2)
//            
//            if !jejuRegion.contains(mapView.centerCoordinate) {
//                mapView.setRegion(jejuRegion, animated: true)
//            }
//        }
    }
}

extension Color {
    func uiColor() -> UIColor {
        let components = self.cgColor?.components
        return UIColor(red: components?[0] ?? 0, green: components?[1] ?? 0, blue: components?[2] ?? 0, alpha: components?[3] ?? 1)
    }
}

extension MKCoordinateRegion {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let spanHalfLat = self.span.latitudeDelta / 2.0
        let spanHalfLon = self.span.longitudeDelta / 2.0
        
        let minLat = self.center.latitude - spanHalfLat
        let maxLat = self.center.latitude + spanHalfLat
        let minLon = self.center.longitude - spanHalfLon
        let maxLon = self.center.longitude + spanHalfLon
        
        return (minLat...maxLat).contains(coordinate.latitude) && (minLon...maxLon).contains(coordinate.longitude)
    }
}
