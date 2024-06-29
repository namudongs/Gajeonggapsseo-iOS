//
//  Gajeonggapsseo_iOSApp.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI
import Firebase

@main
struct Gajeonggapsseo_iOSApp: App {
    @StateObject private var manager = FirestoreManager()
    @State private var centers: [any Center] = []
    @State private var isLoading = true  // 로딩 상태를 관리하는 변수
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoading {
                    ProgressView("데이터를 불러오는 중입니다..")
                        .progressViewStyle(DefaultProgressViewStyle())
                } else {
                    MapView(centers: $centers)
                }
            }
            .onAppear {
                manager.listenToGarbageRequests()
                DataLoader.shared.loadAllData { result in
                    switch result {
                    case .success(let centers):
                        self.centers = centers + manager.garbageRequests
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self.isLoading = false
                }
            }
            .environmentObject(manager)
        }
    }
}
