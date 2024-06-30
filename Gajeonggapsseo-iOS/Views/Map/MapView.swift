//
//  MainView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Binding var centers: [any Center]
    @State private var selectedCenter: (any Center)?
    @State private var selectedCleanHouse = true
    @State private var selectedRecycleCenter = true
    @State private var selectedGarbageRequest = true
    @State private var selectedCenters: [any Center] = []
    @State private var sheetPresent: Bool = false
    @State var navigateAcceptanceData: (Request?, Bool) = (nil, false)
    @State var navigateProgressData: (Request?, Bool) = (nil, false)
    
    var body: some View {
        ZStack {
            MapViewRepresentable(centers: $centers,
                                 region: $region,
                                 selectedCenter: $selectedCenter,
                                 sheetPresent: $sheetPresent, 
                                 selectedCleanHouse: $selectedCleanHouse,
                                 selectedRecycleCenter: $selectedRecycleCenter,
                                 selectedGarbageRequest: $selectedGarbageRequest)
            .edgesIgnoringSafeArea(.all)
            .bottomSheet(isPresented: $sheetPresent,
                         sheetCornerRadius: 15,
                         isTransparentBG: false) {
                CustomSheetView(sheetPresent: $sheetPresent, selectedCenter: $selectedCenter, navigateAcceptanceData: $navigateAcceptanceData, navigateProgressData: $navigateProgressData)
            } onDismiss: {
                selectedCenter = nil
            }
            .onChange(of: firestoreManager.garbageRequests) { newValue in
                print("onChange Trigger")
                centers.removeAll { center in
                    center is Request
                }
                centers += newValue
            }

            GeometryReader { geo in
                VStack(spacing: 0) {
                    // 배출 대행 수행 중 컴포넌트
//                    RoundedRectangle(cornerRadius: 55)
//                        .foregroundColor(.white)
//                        .frame(height: 66)
//                        .padding(.horizontal, 16)
//                        .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
//                        .overlay {
//                            HStack(spacing: 0) {
//                                Spacer()
//                                Image("PurpleMapPin")
//                                    .resizable()
//                                    .frame(width: 35, height: 35)
//                                    .padding(.leading, 25)
//                                    .padding(.top, 5)
//                                Spacer()
//                                Text("배출 대행 1건 수행중")
//                                    .font(.system(size: 20, weight: .semibold))
//                                Spacer()
//                                Button {
//                                    
//                                } label: {
//                                    ZStack {
//                                        RoundedRectangle(cornerRadius: 55)
//                                            .frame(width: 104, height: 56)
//                                        Text("완료하기")
//                                            .font(.system(size: 18))
//                                            .foregroundColor(.white)
//                                    }
//                                }
//                                .foregroundColor(.requestAgent)
//                                .padding(.trailing, 21)
//                            }
//                        }
                    Spacer()
                    // 센터 필터 컴포넌트
                    HStack(spacing: 0) {
                        Spacer()
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(selectedCleanHouse ? Color(hex: "B3C8FF") : .white)
                                .frame(width: 51, height: 51)
                                .padding(.trailing, 16)
                                .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                                .overlay {
                                    Image("LightblueMapPin")
                                        .resizable()
                                        .frame(width: 32, height: 38)
                                        .padding(.trailing, 16)
                                        .padding(.top, 5)
                                        .opacity(selectedCleanHouse ? 1 : 0.3)
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedCleanHouse.toggle()
                                    }
                                    
                                }
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(selectedRecycleCenter ? Color(hex: "B3C8FF") : .white)
                                .frame(width: 51, height: 51)
                                .padding(.trailing, 16)
                                .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                                .overlay {
                                    Image("BlueMapPin")
                                        .resizable()
                                        .frame(width: 32, height: 38)
                                        .padding(.trailing, 16)
                                        .padding(.top, 5)
                                        .opacity(selectedRecycleCenter ? 1 : 0.3)
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedRecycleCenter.toggle()
                                    }
                                }
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(selectedGarbageRequest ? Color(hex: "B3C8FF") : .white)
                                .frame(width: 51, height: 51)
                                .padding(.trailing, 16)
                                .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                                .overlay {
                                    Image("OrangeMapPinV")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .padding(.trailing, 16)
                                        .padding(.top, 5)
                                        .opacity(selectedGarbageRequest ? 1 : 0.3)
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedGarbageRequest.toggle()
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 23)
                    // 대행 수행, 배출 요청 컴포넌트
                    HStack(spacing: 9) {
                        NavigationLink {
                            ListAgentAcceptanceView()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex: "FF881B"))
                                    .frame(height: 74)
                                    .padding(.leading, 16)
                                    .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
                                Text("대행 수행")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.leading, 16)
                            }
                        }
                        NavigationLink {
                            ListAgentRequestView()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex: "2260FE"))
                                    .frame(height: 74)
                                    .padding(.trailing, 16)
                                    .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
                                Text("배출 요청")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                    .padding(.bottom, 35)
                    .navigationDestination(isPresented: $navigateAcceptanceData.1) {
                        if let request = navigateAcceptanceData.0 {
                            AgentAcceptanceView(request: request)
                        }
                    }
                    .navigationDestination(isPresented: $navigateProgressData.1) {
                        if let request = navigateProgressData.0 {
                            AgentExecutionView(request: request)
                        }
                    }
                }
            }
        }
    }
}
