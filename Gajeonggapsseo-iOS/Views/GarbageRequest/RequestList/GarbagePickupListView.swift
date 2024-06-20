//
//  GarbagePickupListView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/19/24.
//

import SwiftUI

struct GarbagePickupListView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        List(firestoreManager.garbageRequests) { request in
            let isAccepted = request.status != .requested
            let isPickuped = request.status == .pickuped
            let isCompleted = request.status == .completed
            
            VStack(alignment: .leading) {
                if isAccepted {
                    Text("정보: \(request.address)")
                    Text("수락한 사람: \(request.helperId ?? "없습니다")")
                    Text("위도: \(request.latitude), 경도: \(request.longitude)")
                    Text("상태: \(request.status)")
                    
                    if !isCompleted {
                        Button(isPickuped ? "완료하기" : "픽업하기") {
                            isPickuped
                            ? firestoreManager.completeGarbageRequest(request.id ?? "")
                            : firestoreManager.pickUpGarbageRequest(request.id ?? "")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .onAppear {
            firestoreManager.fetchGarbageRequests()
        }
    }
}