//
//  ProgressStatusView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/29/24.
//

import SwiftUI

struct ProgressStatusView: View {
    
    var isAgentrequest: Bool = false
    
    var status: RequestStatus
    
    var body: some View {
        GeometryReader { geometry in
            let buttonWidth = (geometry.size.width-30-24) / 4 // spacing 과 화살표 크기를 제외
            let buttonHeight = buttonWidth

            HStack(spacing: 4) {
                let isRequestedDone = (status == .accepted
                                       || status == .pickedUp
                                       || status == .completed)
                
                let isAcceptedDone = (status == .pickedUp
                                      || status == .completed)
                
                let isPickedUpDone = status == .completed
                
                let isCompletedDone = status == .completed
                
                stageRectangle(
                    content: "수락",
                    isDone: isRequestedDone,
                    isCurrentStage: status == .requested
                )
                arrowItem
                
                stageRectangle(
                    content: "수거",
                    isDone: isAcceptedDone,
                    isCurrentStage: status == .accepted
                )
                arrowItem
                
                stageRectangle(
                    content: "배출",
                    isDone: isPickedUpDone,
                    isCurrentStage: status == .pickedUp
                )
                arrowItem
                
                // TODO: 정산 과정이 포함되면 수정
                stageRectangle(
                    content: isAgentrequest ? "완료" : "완료",
                    isDone: isCompletedDone,
                    isCurrentStage: false
                )
            }
            .frame(width: geometry.size.width, height: buttonHeight)
        }
        .frame(height: 100)
    }
}

extension ProgressStatusView {
    @ViewBuilder
    private var arrowItem: some View {
        Image(systemName: "arrowtriangle.right.fill")
            .resizable()
            .frame(width: 11, height: 11)
            .foregroundColor(.requestAgent)
    }

    @ViewBuilder
    private func stageRectangle(content: String, isDone: Bool, isCurrentStage: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isDone ? .subRequestAgent :Color(hex: "EEEEEE"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(isCurrentStage ? .requestAgent : .clear,
                        lineWidth: isCurrentStage ? 3 : 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(content)
                .font(.headline)
                .foregroundColor(isDone ? .requestAgent : .black)
        }
    }
}

#Preview {
    ProgressStatusView(isAgentrequest: false, status: .completed)
}
