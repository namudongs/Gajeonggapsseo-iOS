//
//  GarbageRequestListView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI

struct GarbageRequestListView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        List(firestoreManager.garbageRequests) { request in
            VStack(alignment: .leading) {
                Text("주소: \(request.address)")
                Text("쓰레기 종류: \(request.garbageType)")
                Text("배출 요청 상태: \(request.status)")
                if request.status == .requested {
                    Button("수락하기") {
                        firestoreManager.acceptGarbageRequest(request.id ?? "", helperId: "acceptedUser")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .onAppear {
            firestoreManager.fetchGarbageRequests()
        }
    }
}
