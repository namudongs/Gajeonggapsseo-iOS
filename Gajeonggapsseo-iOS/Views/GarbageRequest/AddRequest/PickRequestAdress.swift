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
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            MapViewCoordinator(locationManager: locationManager)
                .ignoresSafeArea(edges: .top)
                .overlay {
                    VStack(spacing: 0) {
                        Image(systemName: "map.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(locationManager.isChanging ? .gray : .red)
                            .cornerRadius(36)
                        
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(locationManager.isChanging ? .gray : .red)
                            .frame(width: 10, height: 10)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(y: -3)
                            .padding(.bottom, 40)
                    }
                    .offset(y: locationManager.isChanging ? 0 : 5)
                }
                
                .onChange(of: locationManager.isChanging) { newValue in
                    print(newValue)
                    print("\(locationManager.currentPlace)")
                }
            
            Button(action: {
                
            }) {
                Text("현재 위치 프린트")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct MapViewCoordinator: UIViewRepresentable {
    @StateObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> some UIView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
