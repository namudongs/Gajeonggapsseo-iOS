//
//  AcceptionRequestView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/26/24.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct AcceptionRequestView: View {
    var garbageRequest: Request =
        Request(id: UUID(),
                type: .garbageRequest,
                address: "주소",
                coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                garbageType: "플라스틱",
                amount: "0",
                requestTime: Timestamp(date: Date()),
                preferredPickupTime: Timestamp(date: Date()),
                status: .accepted,
                description: ""
        )
    
    // Section Row
    @State private var isGarbageTypeChecked: Bool = false
    @State private var isRequestTimeChecked: Bool = false
    @State private var isAddressChecked: Bool = false
    @State private var isNearbyCenterChecked: Bool = false
    // TODO: 변수명 변경
    @State private var isAgentFeeChecked: Bool = false
    
    
    @State private var requestStatus: RequestStatus = .accepted
    
    // Buttons
    /// 배출 대행
    var isPossibleToAcceptRequest: Bool {
        isGarbageTypeChecked
        && isRequestTimeChecked
        && isAddressChecked
        && isNearbyCenterChecked
//        && isAgentFeeChecked
    }
    var isAcceptedRequest: Bool {
        switch requestStatus {
        case .requested:
            false
        case .accepted:
            true
        case .pickedUp:
            true
        case .completed:
            true
        }
    }
    var acceptButtonColor: Color {
        if isAcceptedRequest {
            .subRequestAgent
        } else if isPossibleToAcceptRequest {
            .requestAgent
        } else {
            Color(hex: "C4C4C4")
        }
    }
    
    /// 수거
    var isPickedUpComplete: Bool {
        switch requestStatus {
        case .requested:
            false
        case .accepted:
            false
        case .pickedUp:
            true
        case .completed:
            true
        }
    }
    var pickUpButtonColor: Color {
        if isPickedUpComplete {
            .subRequestAgent
        } else if isAcceptedRequest {
            .requestAgent
        } else {
            Color(hex: "C4C4C4")
        }
    }
    @State private var isDisplayedPickUpDetail: Bool = false
    
    /// 배출
    var isDisposalComplete: Bool {
        switch requestStatus {
        case .requested:
            false
        case .accepted:
            false
        case .pickedUp:
            false
        case .completed:
            true
        }
    }
    var disposalButtonColor: Color {
        if isDisposalComplete {
            .subRequestAgent
        } else if isPickedUpComplete {
            .requestAgent
        } else {
            Color(hex: "C4C4C4")
        }
    }
    @State private var isDisplayedDisposalDetail: Bool = false
    
    var body: some View {
        ZStack {
            Color(!isAcceptedRequest ? .listBackground : .white).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    if requestStatus == .requested {
                        garbageTypeRow
                        
                        requestTimeRow
                        
                        adressRow
                        
                        nearbyCenterRow
                        
//                        agentFeeRow
                        
                        Spacer().frame(height: 14)
                    } else if requestStatus == .accepted {
                        pickUpView
                        
                        if !isDisplayedPickUpDetail {
                            Spacer().frame(height: 260)
                        }
                    } else if requestStatus == .pickedUp {
                        pickUpView
                        
                        disposalView
                        
                        if !isDisplayedPickUpDetail && !isDisplayedDisposalDetail {
                            Spacer().frame(height: 206)
                        }
                    } else if requestStatus == .completed {
                        pickUpView
                        
                        disposalView
                        
                        completeView
                        
                        if !isDisplayedPickUpDetail && !isDisplayedDisposalDetail {
                            Spacer().frame(height: 122)
                        }
                    }
                    
                    buttonsView
                    
//                    if !isAcceptedRequest {
//                        garbageTypeRow
//                        
//                        requestTimeRow
//                        
//                        adressRow
//                        
//                        nearbyCenterRow
//                        
//                        agentFeeRow
//                        
//                        Spacer().frame(height: 14)
//                    } else {
//                        pickUpView
//                        
//                        if isPickedUpComplete {
//                            disposalView
//                        }
//                        
//                        if !isDisplayedPickUpDetail {
//                            Spacer().frame(height: !isPickedUpComplete ? 240 : 146)
//                        }
//                    }
//                    
//                    buttonsView
                    
                } // VStack
                .padding(.horizontal, 16)
            } // ScrollView
            .navigationTitle("배출 대행하기")
            .navigationBarTitleDisplayMode(.inline)
        } // ZStack
    }
}

extension AcceptionRequestView {
    // MARK: - 품목
    private var garbageTypeRow: some View {
        VStack(alignment: .leading){
            sectionHeader(title: "품목")
            
            HStack(spacing: 15) {
                HStack {
                    Text("\(garbageRequest.garbageType) ")
                        .font(.title3)
                        .fontWeight(.bold)
                    + Text("\(garbageRequest.amount)")
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
                    Text("6월 26일 수요일 20:29")
                        .foregroundColor(.requestAgent)
                        .font(.headline)
                        .fontWeight(.bold)
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
                
                // TODO: 지도로 이동 동작 추가
                Text("지도에서 찾기")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "585858"))
                    .padding(.trailing, 48)
                
            }
            
            // TODO: 텍스트 길이에 따라 동적으로 바꾸기
            HStack(spacing: 15) {
                HStack {
                    Text("\(garbageRequest.address) ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.requestAgent)
                    
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
                
                // TODO: 지도로 이동 동작 추가
                Text("지도에서 찾기")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "585858"))
                    .padding(.trailing, 48)
                
            }
            
            HStack(spacing: 15) {
                HStack {
                    // TODO: 모델 수정
                    // TODO: 텍스트 길이에 따라 동적으로 바꾸기
                    Text("\(garbageRequest.address) ")
                        .font(.headline)
                        .fontWeight(.medium)
                    
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
    // TODO: 변수명 변경
    private var agentFeeRow: some View {
        VStack(alignment: .leading){
            sectionHeader(title: "배출 대행 수고비")
            
            HStack(spacing: 15) {
                ZStack {
                    HStack {
                        Spacer()
                        // TODO: 금액 받아오기
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
    
    // MARK: - 수거 내용
    @ViewBuilder
    private var pickUpView: some View {
        HStack {
            Text(!isPickedUpComplete
                 ? "플라스틱이 수거를 기다리는 중이에요"
                 : "플라스틱이 수거 완료되었어요!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(!isPickedUpComplete
                                 ? .requestAgent
                                 : .black)
            Spacer()
        } // HStack
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 68)
                .foregroundColor(!isPickedUpComplete
                                 ? Color(hex: "F2EDFF")
                                 : Color(hex: "EEEEEE"))
        )

        if !isPickedUpComplete {
            HStack {
                Text("요청 시간")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // TODO: 날짜 받아오기
                Text("6월 26일 수요일 20:29")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.requestAgent)
            }
            
            HStack {
                Text("위치 정보")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(garbageRequest.address)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.requestAgent)
            }
            .padding(.top, -16)
        }
        
        HStack (alignment: .center){
            // TODO: 상세 정보 추가
            Text("상세 정보 확인하기")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.requestAgent)
            
            Image(systemName: isDisplayedPickUpDetail
                  ? "minus.circle"
                  : "plus.circle")
                .resizable()
                .frame(width: 13, height: 13)
                .foregroundStyle(.requestAgent)
            
            Spacer()
        }
        .onTapGesture {
            isDisplayedPickUpDetail.toggle()
        }
        
        if isDisplayedPickUpDetail {
            VStack(spacing: 18) {
                VStack {
                    HStack {
                        sectionHeader(title: "품목")
                        Spacer()
                    }
                    
                    sectionBody(content: "\(garbageRequest.garbageType) \(garbageRequest.amount) 봉지")
                }
                
                VStack {
                    HStack {
                        sectionHeader(title: "요청 시간")
                        Spacer()
                    }
                    
                    // TODO: 날짜 받아오기
                    sectionBody(content: "6월 26일 수요일 20:29")
                }
                
                VStack {
                    HStack {
                        sectionHeader(title: "위치 정보")
                        Spacer()
                        
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 9,height: 9)
                        
                        // TODO: 지도로 이동 동작 추가
                        Text("지도에서 찾기")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "585858"))
                            .padding(.trailing, 48)
                    }
                    
                    sectionBody(content: "\(garbageRequest.address)")
                }
                
                VStack {
                    HStack {
                        sectionHeader(title: "근처 배출 장소")
                        Spacer()
                        
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 9,height: 9)
                        
                        // TODO: 지도로 이동 동작 추가
                        Text("지도에서 찾기")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "585858"))
                            .padding(.trailing, 48)
                    }
                    
                    // TODO: 근처 주소 받아오기
                    sectionBody(content: "\(garbageRequest.address)")
                }
                
//                HStack {
//                    sectionHeader(title: "배출 대행 수고비")
//                    Spacer()
//                    
//                    Text("5,000")
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                    Text("₩")
//                        .font(.subheadline)
//                        .fontWeight(.regular)
//                        .foregroundColor(Color(hex: "727272"))
//                }
                
                Spacer().frame(height: 40)
            }
            
        }
        
    }
    
    // MARK: - 배출 내용
    @ViewBuilder
    private var disposalView: some View {
        HStack {
            Text(!isDisposalComplete
                 ? "분리 배출을 기다리는 중이에요"
                 : "분리 배출 대행이 완료되었어요!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(!isDisposalComplete
                                 ? .requestAgent
                                 : .black)
            Spacer()
        } // HStack
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 68)
                .foregroundColor(!isPickedUpComplete
                                 ? Color(hex: "F2EDFF")
                                 : Color(hex: "EEEEEE"))
        )

        
        HStack (alignment: .center){
            Text("상세 정보 확인하기")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.requestAgent)
            
            Image(systemName: isDisplayedDisposalDetail
                  ? "minus.circle"
                  : "plus.circle")
                .resizable()
                .frame(width: 13, height: 13)
                .foregroundStyle(.requestAgent)
            Spacer()
        }
        .onTapGesture {
            // TODO: 배출 디테일 뷰 추가
            isDisplayedDisposalDetail.toggle()
        }
    }
    
    @ViewBuilder
    private var completeView: some View {
        HStack {
            Text("대행비 정산 완료!")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.requestAgent)
            Spacer()
        } // HStack
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 68)
                .foregroundColor(.subRequestAgent)
        )
    }
    
    // MARK: - 버튼들
    @ViewBuilder
    private var buttonsView: some View {
        // 배출 대행 수락하기
        Button {
            // TODO: 서버에 요청 보내는 동작 추가
            self.requestStatus = .accepted
            
        } label: {
            HStack {
                Spacer()
                Text(isAcceptedRequest
                     ? "배출 대행 수락완료!"
                     : "배출 대행 수락하기"
                )
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 55)
                    .frame(height: 68)
                    .foregroundColor(acceptButtonColor)
            )
        }
        .disabled(
            !isPossibleToAcceptRequest
            || requestStatus != .requested
        )
        
        Image(systemName: "arrowshape.down.fill")
            .foregroundColor(isAcceptedRequest
                             ? .requestAgent
                             : Color(hex: "C4C4C4")
                            )
        
        
        // 수거 완료하기
        Button {
            // TODO: 서버에 요청 보내는 동작 추가
            self.requestStatus = .pickedUp
        } label: {
            HStack {
                Spacer()
                Text(isPickedUpComplete
                     ? "수거 완료!"
                     : "수거 완료하기"
                )
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 55)
                    .frame(height: 68)
                    .foregroundColor(pickUpButtonColor)
            )
        }
        .disabled(requestStatus != .accepted)
        
        Image(systemName: "arrowshape.down.fill")
            .foregroundColor(isPickedUpComplete
                             ? .requestAgent
                             : Color(hex: "C4C4C4")
                            )
        
        // 배출 완료하기
        Button {
            // TODO: 서버에 요청 보내는 동작 추가
            self.requestStatus = .completed
        } label: {
            HStack {
                Spacer()
                Text(isDisposalComplete
                     ? "배출 완료!"
                     : "배출 완료하기"
                )
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 55)
                    .frame(height: 68)
                    .foregroundColor(disposalButtonColor)
            )
        }
        .disabled(requestStatus != .pickedUp)
    }
    
    
    @ViewBuilder
    func sectionHeader(title: String) -> some View {
        Text("\(title)")
            .padding(.leading, 12)
            .padding(.bottom, 4)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: "585858"))
    }
    
    @ViewBuilder
    func sectionBody(content: String) -> some View {
        HStack {
            Text("\(content)")
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 54)
                .foregroundStyle(Color(hex: "F4F4F4"))
        )
    }
    
    @ViewBuilder
    func sectionCheckButton(for flag: Binding<Bool>) -> some View {
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
        }
    }
}

#Preview {
    AcceptionRequestView()
}
