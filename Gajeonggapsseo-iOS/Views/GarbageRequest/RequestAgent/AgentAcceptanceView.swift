//
//  AgentAcceptanceView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/29/24.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct AgentAcceptanceView: View {
//    @EnvironmentObject var manager: FirestoreManager
    
    var request: Request
    
    // Section Row 체크 버튼
    @State private var isGarbageTypeChecked: Bool = false
    @State private var isRequestTimeChecked: Bool = false
    @State private var isAddressChecked: Bool = false
    @State private var isNearbyCenterChecked: Bool = false
    @State private var isAgentFeeChecked: Bool = false
    
    // 버튼 클릭 여부
    private var isPossibleToAcceptRequest: Bool {
        isGarbageTypeChecked
        && isRequestTimeChecked
        && isAddressChecked
        && isNearbyCenterChecked
//        && isAgentFeeChecked
    }
    
    var body: some View {
        ZStack {
            Color(.listBackground).ignoresSafeArea()
            
            VStack(spacing: 28) {
                garbageTypeRow
                
                requestTimeRow
                
                adressRow
                
                nearbyCenterRow
                
//                agentFeeRow
                Spacer()
                
                if isPossibleToAcceptRequest {
                    alertText
                }
                
                acceptanceButton
                    .padding(.bottom)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("대행 수락하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension AgentAcceptanceView {
    // MARK: - 품목
    private var garbageTypeRow: some View {
        VStack(alignment: .leading){
            sectionHeader(title: "품목")
            
            HStack(spacing: 15) {
                HStack {
                    Text("\(request.garbageType) ")
                        .font(.title3)
                        .fontWeight(.bold)
                    + Text("\(request.amount)")
                        .foregroundColor(.requestAgent)
                        .font(.title3)
                        .fontWeight(.bold)
                    + Text("봉지")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                } // HStack
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 68)
                        .foregroundStyle(.white)
                )
                sectionCheckButton(for: $isGarbageTypeChecked)
            } // HStack
        } // VStack
    }
    
    // MARK: - 요청 시간
    private var requestTimeRow: some View {
        VStack(alignment: .leading){
            sectionHeader(title: "요청 시간")
            
            HStack(spacing: 15) {
                HStack {
                    // TODO: 모델에서 시간 불러오기
                    Text("\(request.preferredPickupTime)")
                        .foregroundColor(.requestAgent)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)       
                        .truncationMode(.tail)
                    Spacer()
                } // HStack
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 68)
                        .foregroundStyle(.white)
                )
                sectionCheckButton(for: $isRequestTimeChecked)
            } // HStack
        } // VStack
    }
    
    // MARK: - 위치정보
    private var adressRow: some View {
        VStack(alignment: .leading){
            HStack {
                sectionHeader(title: "위치 정보")
                Spacer()
                
                Image(systemName: "location")
                    .resizable()
                    .frame(width: 9,height: 9)
                    .foregroundColor(Color(hex: "9C9C9C"))
                
                // TODO: 지도로 이동 동작 추가
                Text("지도에서 찾기")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "9C9C9C"))
                    .padding(.trailing, 48)
                
            }
            
            HStack(spacing: 15) {
                HStack {
                    Text("\(request.address) ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.requestAgent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .truncationMode(.tail)
                    
                    Spacer()
                } // HStack
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 68)
                        .foregroundStyle(.white)
                )
                sectionCheckButton(for: $isAddressChecked)
            } // HStack
        } // VStack
    }
    
    // MARK: - 근처 배출 장소
    private var nearbyCenterRow: some View {
        VStack(alignment: .leading){
            HStack {
                sectionHeader(title: "근처 배출 장소")
                Spacer()
                
                Image(systemName: "location")
                    .resizable()
                    .frame(width: 9,height: 9)
                    .foregroundColor(Color(hex: "9C9C9C"))
                
                // TODO: 지도로 이동 동작 추가
                Text("지도에서 찾기")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "9C9C9C"))
                    .padding(.trailing, 48)
                
            }
            
            HStack(spacing: 15) {
                HStack {
                    // TODO: 근처 배출 장소 찾기
                    // TODO: 텍스트 길이에 따라 동적으로 바꾸기
                    Text("\(request.address) ")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "878787"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .truncationMode(.tail)
                    Spacer()
                    
                    // TODO: 거리 계산 추가
                    Text("300m")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "727272"))
                } // HStack
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 68)
                        .foregroundStyle(.white)
                )
                sectionCheckButton(for: $isNearbyCenterChecked)
            } // HStack
        } // VStack
    }
    
    // MARK: - 배출 대행 수고비
    private var agentFeeRow: some View {
        VStack(alignment: .leading){
            sectionHeader(title: "배출 대행 수고비")
            
            HStack(spacing: 15) {
                ZStack {
                    HStack {
                        Spacer()
                        // TODO: 금액 받아오기
                        // TODO: , 넣어서 파싱하기
                        Text("5,000원")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.requestAgent)
                        Spacer()
                    } // HStack
                    
                    HStack {
                        Spacer()
                        Text("₩")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.requestAgent)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 68)
                        .foregroundColor(.subRequestAgent)
                )
                sectionCheckButton(for: $isAgentFeeChecked)
            } // HStack
        } // VStack
    }
    
    
    // MARK: - 주의 텍스트
    @ViewBuilder
    private var alertText: some View {
        Text("요청 수락 후에는 취소할 수 없습니다.")
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(.requestAgent)
    }
    
    // MARK: - 배출 대행 수락 버튼
    @ViewBuilder
    private var acceptanceButton: some View {
        Button {
            // TODO: 서버에 요청 보내는 동작 추가
        } label: {
            ButtonLabel(content: "배출 대행 수락하기", isAgentRequst: false, isDisabled: !isPossibleToAcceptRequest)
        }
        .disabled(
            !isPossibleToAcceptRequest
        )
    }
    
    // MARK: - 섹션 헤더
    @ViewBuilder
    private func sectionHeader(title: String) -> some View {
        Text("\(title)")
            .padding(.leading, 12)
            .padding(.bottom, 7)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: "585858"))
        // TODO: 색상 Asset에 추가
    }
    
    
    // MARK: - 섹션 체크버튼
    @ViewBuilder
    private func sectionCheckButton(for flag: Binding<Bool>) -> some View {
        Button {
            flag.wrappedValue.toggle()
        } label: {
            Image(systemName:
                    flag.wrappedValue
                  ? "checkmark.circle.fill"
                  : "checkmark.circle"
            )
            .resizable()
            .frame(width: 22, height: 22)
            .foregroundColor(flag.wrappedValue
                             ? .requestAgent
                             :Color(hex: "C4C4C4")
            )
            // TODO: 색상 Asset에 추가
        }
    }
}
#Preview {
    AgentAcceptanceView(request: Request(
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
