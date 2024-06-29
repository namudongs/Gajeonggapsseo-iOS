//
//  CleanHouseSheetView.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/30/24.
//

import SwiftUI

struct CleanHouseSheetView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var sheetPresent: Bool
    var center: (any Center)?
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("LightblueMapPin")
                    .resizable()
                    .frame(width: 35, height: 41)
                    .padding(.top, 5)
                Text("\(center?.description ?? "")")
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
                    Text("06:00 ~ 24:00").font(.system(size: 18, weight: .regular))
                    Text("\(center?.address ?? "")".replacingOccurrences(of: "제주특별자치도 ", with: ""))
                        .font(.system(size: 18, weight: .regular))
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
                .padding(.horizontal, 30)
                .onTapGesture {
                    if let currentLocation = locationManager.currentLocation, let centerLocation = center?.coordinate {
                        locationManager.openDirections(from: currentLocation.coordinate, to: centerLocation, for: center?.description ?? "")
                    }
                }
            Spacer()
        }
        .padding(.top)
    }
}

//#Preview {
//    CleanHouseSheetView()
//}
