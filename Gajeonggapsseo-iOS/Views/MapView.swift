//
//  MainView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/20/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Binding var centers: [any Center]
    @State private var selectedCenter: (any Center)?
    @State private var sheetPresent: Bool = false
    
    var body: some View {
        ZStack {
            MapViewRepresentable(centers: $centers, 
                                 region: $region,
                                 selectedCenter: $selectedCenter,
                                 sheetPresent: $sheetPresent)
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $sheetPresent) {
                    selectedCenter = nil
                } content : {
                    VStack {
                        if let jejuClean = selectedCenter as? JejuClean {
                            Text("\(jejuClean.description)")
                        }
                        
                        if let jejuRecycle = selectedCenter as? JejuRecycle {
                            Text("\(jejuRecycle.description)")
                        }
                        
                        if let seogwipoClean = selectedCenter as? SeogwipoClean {
                            Text("\(seogwipoClean.description)")
                        }
                        
                        if let seogwipoRecycle = selectedCenter as? SeogwipoRecycle {
                            Text("\(seogwipoRecycle.description)")
                        }
                        
                        if let request = selectedCenter as? Request {
                            Text("\(request.requestTime)")
                        }
                    }
                    .presentationDetents([.height(260)])
                }
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // 배출 대행 수행 중 컴포넌트
                    RoundedRectangle(cornerRadius: 55)
                        .foregroundColor(.white)
                        .frame(height: 66)
                        .padding(.horizontal, 16)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
                        .overlay {
                            HStack {
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .frame(width: 25.96, height: 26.65)
                                    .padding(.leading, 41)
                                Spacer()
                                Text("배출 대행 1건 수행중")
                                    .font(.system(size: 20, weight: .semibold))
                                Spacer()
                                Button {
                                    
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 55)
                                            .frame(width: 104, height: 56)
                                        Text("완료하기")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }
                                }
                                .foregroundColor(.requestAgent)
                                .padding(.trailing, 21)
                            }
                        }
                    Spacer()
                    // 센터 필터 컴포넌트
                    HStack(spacing: 0) {
                        Spacer()
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(.white)
                                .frame(width: 51, height: 51)
                                .padding(.trailing, 16)
                                .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                                .onTapGesture {
                                    
                                }
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(.white)
                                .frame(width: 51, height: 51)
                                .padding(.trailing, 16)
                                .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                                .onTapGesture {
                                    
                                }
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(.white)
                                .frame(width: 51, height: 51)
                                .padding(.trailing, 16)
                                .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                                .onTapGesture {
                                    
                                }
                        }
                    }
                    .padding(.bottom, 23)
                    // 대행 수행, 배출 요청 컴포넌트
                    HStack(spacing: 9) {
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.requestAgent)
                                    .frame(height: 74)
                                    .padding(.leading, 16)
                                    .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
                                Text("대행 수행")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.leading, 16)
                            }
                        }
                        Button {
                            
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
                }
            }
        }
    }
}

#Preview {
    MapView(centers: .constant([]))
}
