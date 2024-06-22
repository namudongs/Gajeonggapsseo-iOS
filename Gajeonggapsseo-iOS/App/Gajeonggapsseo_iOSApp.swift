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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
    }
}
