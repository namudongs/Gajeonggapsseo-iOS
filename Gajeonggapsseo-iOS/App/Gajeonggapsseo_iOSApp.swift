//
//  Gajeonggapsseo_iOSApp.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI

@main
struct Gajeonggapsseo_iOSApp: App {
    
    @State private var centers: [Center] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MapView(centers: $centers)
            }
        }
    }
}
