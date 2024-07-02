//
//  PickRequestAdress.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/19/24.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - 맵에서 위치를 선택하는 뷰
struct PickRequestAdress: View {
    @Binding var selectedAddress: String
    @Binding var selectedGeoPoint: CLLocationCoordinate2D
    @Binding var showPickRequestAddressSheet: Bool
    
    @State private var isChanging: Bool = false // 지도의 움직임 여부를 저장하는 프로퍼티
    @State private var currentPlace: String = "위치를 선택해주세요" // 현재 위치의 도로명 주소를 저장하는 프로퍼티
    @State private var currentGeoPoint: CLLocationCoordinate2D? // 현재 위치를 저장하는 프로퍼티
    
    var body: some View {
        VStack {
            PickMapViewRepresentable(isChanging: $isChanging, currentPlace: $currentPlace, currentGeoPoint: $currentGeoPoint)
                .ignoresSafeArea(edges: .top)
                .overlay {
                    VStack(spacing: 0) {
                        Image(isChanging ? "OrangeMapPin" : "OrangeMapPinV")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .overlay {
                                Capsule()
                                    .foregroundColor(Color(hex: "FFDFC2"))
                                    .frame(width: 120, height: 25)
                                    .overlay {
                                        Text("이 위치로 요청하기")
                                            .foregroundColor(Color(hex: "FF881B"))
                                            .font(.system(size: 12, weight: .bold))
                                    }
                                    .onTapGesture {
                                        selectedAddress = currentPlace
                                        selectedGeoPoint = currentGeoPoint ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                                        showPickRequestAddressSheet = false
                                    }
                                    .offset(y: -40)
                            }
                    }
                    .onChange(of: isChanging) { newValue in
                        print(newValue)
                        print("\(isChanging)")
                    }
                }
        }
    }
    
    struct PickMapViewRepresentable: UIViewRepresentable {
        @Binding var isChanging: Bool
        @Binding var currentPlace: String
        @Binding var currentGeoPoint: CLLocationCoordinate2D?
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView(frame: .zero)
            mapView.delegate = context.coordinator
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
            mapView.isRotateEnabled = false
            mapView.showsCompass = false
            
            context.coordinator.checkLocationAuthorization()
            return mapView
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
            var parent: PickMapViewRepresentable
            var locationManager = CLLocationManager()
            
            init(_ parent: PickMapViewRepresentable) {
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
            
            // MARK: - MapView에서 화면이 이동하면 호출되는 메서드
            func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
                DispatchQueue.main.async {
                    self.parent.isChanging = true
                }
            }
            
            // MARK: - MapView에서 화면 이동이 종료되면 호출되는 메서드
            func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
                let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                
                self.parent.currentGeoPoint = location.coordinate
                self.convertLocationToAddress(location: location)
                
                DispatchQueue.main.async {
                    self.parent.isChanging = false
                }
            }
            
            // MARK: - location을 도로명 주소로 변환해주는 메서드
            func convertLocationToAddress(location: CLLocation) {
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let error = error {
                        print("Geocoding error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let placemark = placemarks?.first else {
                        print("No placemarks found")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.parent.currentPlace = "\(placemark.country ?? "") \(placemark.locality ?? "") \(placemark.name ?? "")"
                        print("Current place: \(self.parent.currentPlace)")
                    }
                }
            }
        }
    }
}
