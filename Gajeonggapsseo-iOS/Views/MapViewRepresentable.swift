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
    @Binding var centers: [Center]
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKPointAnnotation.self))
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        context.coordinator.checkLocationAuthorization()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        
        let annotations = centers.compactMap { center -> MKPointAnnotation? in
            guard let coordinate = center.coordinate else { return nil }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = center.type.rawValue
            return annotation
        }
        uiView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func colorForCenterType(_ type: CenterType) -> UIColor {
        switch type {
        case .cleanHouse, .seogwipoCleanHouse:
            return UIColor.blue
        case .recycleCenter, .seogwipoRecycleCenter:
            return UIColor.green
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
            
            let identifier = NSStringFromClass(MKPointAnnotation.self)
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
            } else {
                view?.annotation = annotation
            }
            
            if let title = annotation.title as? String, let center = parent.centers.first(where: { $0.type.rawValue == title }) {
                view?.markerTintColor = parent.colorForCenterType(center.type)
            }
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, clusterAnnotationFor memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
            return MKClusterAnnotation(memberAnnotations: memberAnnotations)
        }
        
        // MARK: - 제주도 밖으로 지도가 이동하지 않게 하는 메소드
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let jejuCenter = CLLocationCoordinate2D(latitude: 33.3628, longitude: 126.5334)
            let jejuRegionRadius: CLLocationDistance = 75000
            let jejuRegion = MKCoordinateRegion(center: jejuCenter, latitudinalMeters: jejuRegionRadius * 2, longitudinalMeters: jejuRegionRadius * 2)
            
            if !jejuRegion.contains(mapView.centerCoordinate) {
                mapView.setRegion(jejuRegion, animated: true)
            }
        }
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
