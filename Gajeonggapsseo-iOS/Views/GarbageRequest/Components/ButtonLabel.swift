//
//  ButtonLabel.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/30/24.
//

import SwiftUI

struct ButtonLabel: View {
    var content: String
    var isAgentRequst: Bool
    var isDisabled: Bool
    
    var labelColor: Color {
        if isDisabled {
            Color(hex: "C4C4C4")
        } else {
            if isAgentRequst {
                .requestAccent
            } else {
                .acceptanceAccent
            }
        }
    }
    var body: some View {
        HStack {
            Spacer()
            Text("\(content)")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 55)
                .frame(height: 68)
                .foregroundColor(labelColor)
        )
    }
}

#Preview {
    ButtonLabel(content: "배출 완료하기", isAgentRequst: false, isDisabled: false)
}
