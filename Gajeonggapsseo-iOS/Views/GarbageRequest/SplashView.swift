//
//  SplashView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/30/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(hex: "2260FE")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image("Splash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                Spacer()
                Text("데이터를 불러오고 있습니다...")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.2))
                    .padding(.bottom, 15)
            }
        }
    }
}

#Preview {
    SplashView()
}
