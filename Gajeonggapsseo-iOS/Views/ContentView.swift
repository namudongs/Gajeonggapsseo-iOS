////
////  ContentView.swift
////  Gajeonggapsseo-iOS
////
////  Created by namdghyun on 6/18/24.
////
//
//import SwiftUI
//import FirebaseFirestore
//
//struct ContentView: View {
//    @EnvironmentObject var manager: FirestoreManager
//    @State private var centers: [any Center] = []
//    @State private var isLoading: Bool = true
//    
//    var body: some View {
//        VStack {
//            NavigationLink {
//                MapView(centers: $centers)
//            } label: {
//                Text("지도에서 찾기")
//            }
//            .buttonStyle(.bordered)
////            .disabled(isLoading)
//            NavigationLink {
//                GarbageRequestView()
//            } label: {
//                Text("배출 요청 하기")
//            }.buttonStyle(.bordered)
//            NavigationLink {
//                GarbageRequestListView()
////                OrderMapView(centers: $centers)
//            } label: {
//                Text("배출 요청 보기")
//            }.buttonStyle(.bordered)
//            NavigationLink {
//                GarbagePickupListView()
//            } label: {
//                Text("배출 대행 수락 목록 보기")
//            }.buttonStyle(.bordered)
//        }
//        .onAppear {
//            manager.listenToGarbageRequests()
//            DataLoader.shared.loadAllData { result in
//                switch result {
//                case .success(let centers):
//                    self.centers = centers + manager.garbageRequests
//                    isLoading = false
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    isLoading = true
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
