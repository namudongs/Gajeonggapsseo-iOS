//
//  ContentView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(firestoreManager.title)")
            Text("\(firestoreManager.name)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
