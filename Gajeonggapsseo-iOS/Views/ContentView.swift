//
//  ContentView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    GarbageRequestView()
                } label: {
                    Text("배출 요청 하기")
                }.buttonStyle(.bordered)
                NavigationLink {
                    GarbageRequestListView()
                } label: {
                    Text("배출 요청 보기")
                }.buttonStyle(.bordered)
                NavigationLink {
                    GarbagePickupListView()
                } label: {
                    Text("배출 대행 수락 목록 보기")
                }.buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    ContentView()
}
