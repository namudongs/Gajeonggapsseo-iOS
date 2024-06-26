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
    @State private var selectedCenter: Center?
    
    var body: some View {
        ZStack {
            MapViewRepresentable(centers: $centers, 
                                 region: $region,
                                 selectedCenter: $selectedCenter)
                .edgesIgnoringSafeArea(.all)
                .bottomSheet(presentationDetents: [.height(100), .medium],
                             isPresented: .constant(true),
                             sheetCornerRadius: 15,
                             largestUndimmedIdentifier: .medium,
                             isTransparentBG: false) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15){
                            let center = selectedCenter
                            TextField("\(center?.rnAdres ?? "Select Center")", text: .constant(""))
                                .padding(.vertical,10)
                                .padding(.horizontal)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.ultraThickMaterial)
                                }
                        }
                        .padding()
                        .padding(.top)
                    }
                    .background(content: {
                        Rectangle()
                            .fill(.white)
                            .ignoresSafeArea()
                    })
                    // MARK: In SwiftUI A ViewController Currently Present Only One Sheet
                    // So If We try to Show Another Sheet It Will not Show Up
                    // But There is a Work Around
                    // Simply Insert All Sheets And FullScreenCover Views to Bottom Sheet View
                    // Because its A New View Controller so It can able to Show Another Sheet
                } onDismiss: {}
        }
    }
}

#Preview {
    MapView(centers: .constant([]))
}
