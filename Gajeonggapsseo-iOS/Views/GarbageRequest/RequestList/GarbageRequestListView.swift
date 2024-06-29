//
//  GarbageRequestListView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI

struct GarbageRequestListView: View {
    @EnvironmentObject var manager: FirestoreManager
    
    var body: some View {
        List(manager.garbageRequests) { request in
            VStack(alignment: .leading) {
                Text("문서 ID: \(request.id.uuidString)")
                Text("주소: \(request.address)")
                Text("쓰레기 종류: \(request.garbageType)")
                Text("배출 요청 상태: \(request.status)")
                if request.status == .requested {
                    Button("수락하기") {
                        manager.acceptGarbageRequest(request.id.uuidString, helperId: "acceptedUser")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
