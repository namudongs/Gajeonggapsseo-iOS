//
//  EmissionRequestView.swift
//  Gajeonggapsseo-iOS
//
//  Created by Damin on 6/25/24.
//

import SwiftUI

enum GarbageCategory: String {
    case garbageBag = "종량제", plasticBag = "비닐", can = "캔", bottle = "병류", polystyrene = "스티로폼", plastic = "플라스틱", clearPet = "투명 페트병", paper = "종이"
}
struct CompletedRequest: Hashable, Identifiable {
    let id = UUID()
    var category: GarbageCategory
    var count: Int
    var date: String
}

struct EmissionRequestView: View {
    @State private var onGoingRequestCount: Int = 1
    var isRequestAccepted: Bool = false
    var requestedTime: String = "6월 25일 화요일 10:00"
    var recentlyCompletedRequestList: [CompletedRequest] = [
        CompletedRequest(category: .plasticBag, count: 2, date: "6.23 일요일"),
        CompletedRequest(category: .plasticBag, count: 2, date: "6.21 금요일"),
        CompletedRequest(category: .plasticBag, count: 2, date: "6.19 수요일")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("진행 중인 요청")
                    .fontWeight(.semibold)
                + Text(" \(onGoingRequestCount)건")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "2260FE"))
            }
            .padding(.leading, 27)

            OnGoingRequestView(isRequestAccepted: isRequestAccepted, requestedTime: requestedTime)
                .frame(height: 68)
                .padding(.horizontal, 18)
            
            Text("최근 완료된 요청")
                .fontWeight(.semibold)
                .padding(.top, 68)
                .padding(.leading, 27)
            
            
            VStack {
                ForEach(recentlyCompletedRequestList) { request in
                    HStack {
                        Text(request.category.rawValue)
                        Text("\(request.count)개")
                        Spacer()
                        Text(request.date)
                    }
                    .foregroundColor(Color(hex: "747474"))
                    
                    Divider()
                }
            }
            .padding(.top, 17)
            .padding(.horizontal, 27)
            
            Text("새로운 요청하기")
                .fontWeight(.heavy)
                .font(.system(size: 22))
                .padding(.top, 49)
                .padding(.leading, 27)
            
            NewRequestSelectionView()
                .padding(.horizontal, 17)
            
        }
//        .navigationBarBackButtonHidden()
        .navigationTitle("Detail View")
        .navigationBarTitleDisplayMode(.large)
    }
}

fileprivate struct OnGoingRequestView: View {
    var isRequestAccepted: Bool
    var requestedTime: String
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color(hex: "D3DFFF"), lineWidth: 2)
            .overlay(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("배출 대행 수락을 기다리는 중 ...")
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                            .foregroundStyle(Color(hex: "2260FE"))
                        Image(systemName: "plus.circle")
                            .foregroundStyle(Color(hex: "2260FE"))
                    }
                    HStack {
                        Text("수거 요청 시간")
                            .fontWeight(.semibold)
                        Text(requestedTime)
                            .foregroundColor(Color(hex: "747474"))
                    }
                    .font(.system(size: 10))
                }
                .padding(.leading, 24)
            }
       
    }
}

fileprivate struct NewRequestSelectionView: View {
     
    let garbageCategoryList: [GarbageCategory] = [
        .garbageBag,
        .plasticBag,
        .can,
        .bottle,
        .polystyrene,
        .plastic,
        .clearPet,
        .paper
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(garbageCategoryList, id: \.self) { item in
                showGarbageCategory(item: item)
            }
        }
    }
    
    @ViewBuilder
    private func showGarbageCategory(item: GarbageCategory) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(hex:"CEDBFD"))
            .frame(height: 84)
            .overlay(alignment: .topLeading) {
                VStack {
                    HStack{
                        Text(item.rawValue)
                            .fontWeight(.semibold)
                            .font(.system(size: 13))
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("아이콘 이미지")
                            .font(.system(size: 11))
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
//                                Image(item.rawValue)
                    }
                }
                .padding(.top, 10)
            }
    }
}

#Preview {
    EmissionRequestView()
}
