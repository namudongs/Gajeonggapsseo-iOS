//
//  AcceptedRequestSheetView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/30/24.
//

import SwiftUI

struct AcceptedRequestSheetView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var sheetPresent: Bool
    @Binding var navigateProgressData: (Request?, Bool)
    var center: Request
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("OrangeMapPin")
                    .resizable()
                    .frame(width: 41, height: 41)
                    .padding(.top, 5)
                Text("\(center.garbageType.rawValue) \(center.amount)봉투")
                    .font(.system(size: 30, weight: .bold))
                Spacer()
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray)
                    .padding([.trailing], 30)
                    .onTapGesture {
                        sheetPresent = false
                    }
            }
            .padding(.top, 10)
            .padding(.leading, 30)
            HStack {
                VStack(alignment: .center, spacing: 9) {
                    Text("위치 정보").font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "7F7F7F"))
                    Text("요청 시간").font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "7F7F7F"))
                    Spacer()
                }
                .padding(.trailing, 22)
                VStack(alignment: .leading, spacing: 9) {
                    Text("\(center.address.replacingOccurrences(of: "대한민국 ", with: ""))").font(.system(size: 18, weight: .regular))
                    Text("\(center.requestTime.dateValue().toYearMonthDayString())").font(.system(size: 18, weight: .regular))
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 30)
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "E1E1E1"))
                    .frame(height: 66)
                    .overlay {
                        Text("길찾기").font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "303030"))
                    }
                    .onTapGesture {
                        if let currentLocation = locationManager.currentLocation {
                            locationManager.openDirections(from: currentLocation.coordinate, to: center.coordinate, for: "배출 요청지")
                        }
                    }
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "FFEBB9"))
                    .frame(width: 190, height: 66)
                    .overlay {
                        Text(center.status == .completed ? "완료된 대행" : "대행 수행 중").font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "FF881B"))
                    }
                    .onTapGesture {
                        if center.status != .requested && center.status != .completed {
                            navigateProgressData.0 = center
                            navigateProgressData.1 = true
                        }
                    }
            }
            .padding(.horizontal, 30)
            Spacer()
        }
        .padding(.top)
    }
}
