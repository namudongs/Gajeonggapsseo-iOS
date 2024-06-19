//
//  GarbagegRequestView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI
import FirebaseFirestore

struct GarbageRequestView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var address: String = ""
    @State private var garbageType: String = ""
    @State private var amount: String = ""
    @State private var preferredPickupTime: Date = Date()
    @State private var userId: String = "User" // 사용자 ID
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("주소")) {
                    TextField("주소 입력", text: $address)
                }
                
                Section(header: Text("쓰레기 종류")) {
                    TextField("쓰레기 종류 입력", text: $garbageType)
                }
                
                Section(header: Text("쓰레기의 양")) {
                    TextField("쓰레기의 양 입력", text: $amount)
                }
                
                Section(header: Text("배출 예정 시간")) {
                    DatePicker("배출 예정 시간 선택", selection: $preferredPickupTime, displayedComponents: .date)
                }
                
                Button(action: submitRequest) {
                    Text("배출 요청하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("배출 요청하기")
        }
    }
    
    func submitRequest() {
        let newRequest = GarbageRequest(
            userId: userId,
            address: address,
            latitude: 0.0, // 위도
            longitude: 0.0, // 경도
            garbageType: garbageType,
            amount: amount,
            requestTime: Timestamp(date: Date()),
            preferredPickupTime: Timestamp(date: preferredPickupTime),
            status: .requested
        )
        
        firestoreManager.addGarbageRequest(newRequest)
    }
}

