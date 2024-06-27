//
//  MainView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Binding var centers: [Center]
    
    var body: some View {
        ZStack {
            MapViewRepresentable(centers: $centers,
                                 region: $region)
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            DataLoader.shared.loadAllData { result in
                switch result {
                case .success(let centers):
                    self.centers = centers.filter { $0.coordinate != nil }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
