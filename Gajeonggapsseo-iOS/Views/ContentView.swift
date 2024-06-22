//
//  ContentView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @State private var centers: [Center] = []
    @State private var requests: [GarbageRequest] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            NavigationLink {
                MapView(centers: $centers)
            } label: {
                Text("지도에서 찾기")
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
            NavigationLink {
                GarbageRequestView()
            } label: {
                Text("배출 요청 하기")
            }.buttonStyle(.bordered)
            NavigationLink {
                GarbageRequestListView()
//                OrderMapView(centers: $centers)
            } label: {
                Text("배출 요청 보기")
            }.buttonStyle(.bordered)
            NavigationLink {
                GarbagePickupListView()
            } label: {
                Text("배출 대행 수락 목록 보기")
            }.buttonStyle(.bordered)
        }
        .onAppear {
            FirestoreManager.shared.listenToGarbageRequests()
            DataLoader.shared.loadAllData { result in
                switch result {
                case .success(let centers):
                    self.centers = centers.filter { $0.coordinate != nil }
                    isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                    isLoading = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
