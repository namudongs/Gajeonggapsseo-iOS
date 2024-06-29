//
//  ListAgentView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn on 6/29/24.
//

import SwiftUI
import FirebaseFirestore

struct ListAgentView: View {
    // onAppear로 서버에서 받아오기
    var garbageRequestList: [GarbageRequest] = [
        GarbageRequest(
            userId: "1",
            address: "제주시 연동 14길 32",
            latitude: 0.0,
            longitude: 0.0,
            garbageType: "플라스틱",
            amount: "1",
            requestTime: Timestamp(date: Date()),
            preferredPickupTime: Timestamp(date: Date()),
            status: .requested),
        GarbageRequest(
            userId: "2",
            address: "제주시 연동 14길 32",
            latitude: 0.0,
            longitude: 0.0,
            garbageType: "유리",
            amount: "1",
            requestTime: Timestamp(date: Date()),
            preferredPickupTime: Timestamp(date: Date()),
            status: .accepted),
        GarbageRequest(
            userId: "3",
            address: "제주시 연동 14길 32",
            latitude: 0.0,
            longitude: 0.0,
            garbageType: "플라스틱",
            amount: "1",
            requestTime: Timestamp(date: Date()),
            preferredPickupTime: Timestamp(date: Date()),
            status: .accepted),
        GarbageRequest(
            userId: "4",
            address: "제주시 연동 14길 32",
            latitude: 0.0,
            longitude: 0.0,
            garbageType: "플라스틱",
            amount: "1",
            requestTime: Timestamp(date: Date()),
            preferredPickupTime: Timestamp(date: Date()),
            status: .pickedUp),
        GarbageRequest(
            userId: "5",
            address: "제주시 연동 14길 32",
            latitude: 0.0,
            longitude: 0.0,
            garbageType: "플라스틱",
            amount: "1",
            requestTime: Timestamp(date: Date()),
            preferredPickupTime: Timestamp(date: Date()),
            status: .completed)
    ]
    
    // TODO: 날짜 설정하게 하기
    //    @State private var selectedYear: Int = 2024
    //    @State private var selectedMonth: Int = 6
    //    @State private var showingPicker = false
    //
    //    let years: [Int] = Array(2000...2030)
    //    let months: [String] = Calendar.current.monthSymbols.map { $0.localizedCapitalized }
    
    var body: some View {
        ScrollView {
            VStack {
                requestCountView
                
                ForEach(garbageRequestList, id: \.id) { request in
                    requestAgentRow(for: request)
                        .padding(.bottom, 7)
                }
                Spacer().frame(height: 64)
                
                completedRequestHeaderView
                
                datePickerView
                
                ForEach(garbageRequestList, id: \.id) { request in
                    completedRequestRow(for: request)
                        .padding(.vertical, 10)
                    Divider()
                }
                .padding(.horizontal, 16)
            } // VStack
            .padding(.horizontal, 18)
            .navigationTitle("대행 수행")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension ListAgentView {
    // MARK: - 진행 중인 대행 뷰
    @ViewBuilder
    private var requestCountView: some View {
        HStack {
            Text("진행 중인 요청")
                .font(.title3)
                .fontWeight(.medium)
            + Text(" \(garbageRequestList.count)건")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.requestAgent)
            Spacer()
        }
        .padding(.leading, 16)
    }
    
    @ViewBuilder
    private func requestAgentRow(for request: GarbageRequest) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // TODO: 아이콘 추가
                Text("\(request.address)")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            HStack {
                // TODO: 품목과 상태에 따른 텍스트 수정
                Text("플라스틱이 수거를 기다리는 중이에요")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.requestAgent)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 80)
                .foregroundColor(.subRequestAgent)
        )
    }
    
    @ViewBuilder
    private var completedRequestHeaderView: some View {
        HStack {
            Text("완료된 대행")
                .font(.title3)
                .fontWeight(.medium)
            Spacer()
        }
        .padding(.leading, 16)
    }
    
    @ViewBuilder
    private var datePickerView: some View {
        HStack {
            Button {
                // TODO: 동작 추가
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            
            Button {
                // TODO: 데이트 피커 추가
            } label: {
                Text("2024년 6월")
                    .fontWeight(.medium)
                    .padding()
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "F4F4F4"))
                    )
            }
            Button {
                // TODO: 동작 추가
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
        }
    }
    @ViewBuilder
    private func completedRequestRow(for request: GarbageRequest) -> some View {
        // TODO: 값 불러와서 띄우기
        HStack {
            Text("클린하우스 01")
                .font(.caption)
                .fontWeight(.regular)
            Spacer()
            
            Text("2024.06.17")
                .font(.caption)
                .fontWeight(.regular)
        }
    }
}


//struct YearMonthPicker: View {
//    @Binding var selectedYear: Int
//    @Binding var selectedMonth: Int
//    let years: [Int] = Array(2000...2030)
//    let months: [String] = Calendar.current.monthSymbols
//
//    var body: some View {
//        VStack {
//            HStack {
//                Picker("Year", selection: $selectedYear) {
//                    ForEach(years, id: \.self) { year in
//                        Text("\(year)").tag(year)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//
//                Picker("Month", selection: $selectedMonth) {
//                    ForEach(1..<months.count+1, id: \.self) { month in
//                        Text(months[month - 1]).tag(month)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//            }
//        }
//    }
//}

#Preview {
    ListAgentView()
}
