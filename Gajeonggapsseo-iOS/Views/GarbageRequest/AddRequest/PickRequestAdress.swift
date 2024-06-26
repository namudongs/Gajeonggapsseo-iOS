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
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var selectedAddress: String
    @Binding var showPickRequestAddressSheet: Bool
    
    var body: some View {
        VStack {
            MapViewCoordinator()
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
                selectedAddress = locationManager.currentPlace
                showPickRequestAddressSheet = false
            }) {
                Text("위치 선택하기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct MapViewCoordinator: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> some UIView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
