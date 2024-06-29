//
//  AgentExecutionView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/29/24.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct AgentExecutionView: View {
    var request: Request
    
    @State private var requestStatus: RequestStatus = .accepted
    
    var body: some View {
        VStack(spacing: 28) {
            VStack (spacing: 7){
                HStack {
                    Text("현황")
                        .padding(.leading, 12)
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "585858"))
                    
                    Spacer()
                }
                
                ProgressStatusView(isAgentrequest: false, status: requestStatus)
            }
            
            sectionRow(header: "품목", content: "\(request.garbageType) \(request.amount)봉투")
            
            // TODO: 날짜 시간 변경
            sectionRow(header: "요청 시간", content: "\(request.preferredPickupTime)")
            
            sectionRow(header: "위치 정보", content: "\(request.address)")
            
            // TODO: 위치 받아오기
            sectionRow(header: "근처 배출 장소", content: "\(request.address)")
            
//            agentFeeRow
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationTitle("진행 중인 대행")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            self.requestStatus = request.status
        })
    }
}

extension AgentExecutionView {
    @ViewBuilder
    private func sectionRow(header: String, content: String) -> some View {
        VStack(spacing: 7){
            HStack {
                Text("\(header)")
                    .padding(.leading, 12)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color(hex: "585858"))
                Spacer()
                
                // TODO: 지도로 이동 동작 추가
                if header == "위치 정보" || header == "근처 배출 장소" {
                    Image(systemName: "location")
                        .resizable()
                        .frame(width: 9,height: 9)

                    Text("지도에서 찾기")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "585858"))
                        .padding(.trailing, 10)
                }
            }
            
            HStack {
                Text("\(content)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "303030"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .truncationMode(.tail)
                
                Spacer()
                if header == "근처 배출 장소" {
                    // TODO: 거리 계산
                    Text("300m")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "727272"))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 52)
                    .foregroundStyle(Color(hex: "F4F4F4"))
            )
            
        }
    }
    
    @ViewBuilder
    private var agentFeeRow: some View {
        HStack {
            Text("배출 대행 수고비")
                .padding(.leading, 12)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(Color(hex: "585858"))
            Spacer()
            
            HStack {
                Text("5,000")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "303030"))
                Text("₩")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color(hex: "585858"))
            }
            .padding()
        }
    }
    
    
}


#Preview {
    AgentExecutionView(request: Request(
        id: UUID(),
        type: .garbageRequest,
        address: "주소",
        coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        garbageType: "플라스틱",
        amount: "0",
        requestTime: Timestamp(date: Date()),
        preferredPickupTime: Timestamp(date: Date()),
        status: .accepted)
    )
}
