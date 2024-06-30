//
//  RecycleSheetView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/30/24.
//

import SwiftUI

struct JejuRecycleSheetView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var sheetPresent: Bool
    var center: JejuRecycle
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("BlueMapPin")
                    .resizable()
                    .frame(width: 35, height: 41)
                    .padding(.top, 5)
                Text("재활용도움센터\(center.dataCode)")
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
                    Text("운영 시간").font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "7F7F7F"))
                    Text("위치 정보").font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "7F7F7F"))
                    Spacer()
                }
                .padding(.trailing, 22)
                VStack(alignment: .leading, spacing: 9) {
                    Text("\(Date.fromOperatingHoursToDateString(center.operatingHours))").font(.system(size: 18, weight: .regular))
                    Text("\(center.address.replacingOccurrences(of: "제주특별자치도 ", with: ""))").font(.system(size: 18, weight: .regular))
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 30)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "CEDBFD"))
                .frame(height: 66)
                .overlay {
                    Text("길찾기").font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "0C4DF5"))
                }
                .onTapGesture {
                    if let currentLocation = locationManager.currentLocation {
                        locationManager.openDirections(from: currentLocation.coordinate, to: center.coordinate, for: "재활용도움센터\(center.dataCode)")
                    }
                }
                .padding(.horizontal, 30)
            Spacer()
        }
        .padding(.top)
    }
}
