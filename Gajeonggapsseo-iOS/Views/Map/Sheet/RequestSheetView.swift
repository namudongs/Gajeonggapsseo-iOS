//
//  RequestSheetView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/30/24.
//

import SwiftUI

struct RequestSheetView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var sheetPresent: Bool
    @Binding var navigateAcceptanceData: (Request?, Bool)
    var center: Request
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("OrangeMapPinV")
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
                    .fill(Color(hex: "FF881B"))
                    .frame(width: 190, height: 66)
                    .overlay {
                        Text("대행 수행").font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }
                    .onTapGesture {
                        print(center.status)
                        if center.status == .requested {
                            navigateAcceptanceData.0 = center
                            navigateAcceptanceData.1 = true
                        }
                    }
            }
            .padding(.horizontal, 30)
            Spacer()
        }
        .padding(.top)
    }
}
