//
//  AgentRequestView.swift
//  Gajeonggapsseo-iOS
//
//  Created by sseungwonnn, Damin on 6/30/24.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct AgentRequestView: View {
    @EnvironmentObject var manager: FirestoreManager
    @EnvironmentObject var lm: LocationManager
    
    @State private var selectedAddress: String = ""
    @State private var showAddressSearchSheet = false
    @State private var showPickRequestAddressSheet = false
    
    @State private var selectedDate: Date = Date.now
    
    @State private var selectedCategories: Set<GarbageCategory> = []
    @State private var garbageBagCount: Int = 1
    @State private var plasticBagCount: Int = 1
    @State private var canCount: Int = 1
    @State private var bottleCount: Int = 1
    @State private var polystyreneCount: Int = 1
    @State private var plasticCount: Int = 1
    @State private var clearPetCount: Int = 1
    @State private var paperCount: Int = 1

    @State private var isDone: Bool = false
    
    var body: some View {
        ZStack{
            Color(.requestBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        HStack {
                            Text("수거 장소")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        
                        HStack {
                            Text("\(selectedAddress)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "303030"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .truncationMode(.tail)
                            Spacer()
                            
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 40)
                                .foregroundStyle(.white)
                        )
                        HStack {
                            Button {
                                showPickRequestAddressSheet = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("현재 위치로 찾기")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.requestAccent)
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                        .foregroundStyle(.requestSub)
                                )
                            }
                            Button {
                                showAddressSearchSheet = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("주소 검색하기")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(hex: "303030"))
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.requestAccent, lineWidth: 2)
                                        .frame(height: 50)
                                )
                            }
                        }
                    } // VStack; 수거 장소
                    
                    VStack(spacing: 18) {
                        HStack {
                            Text("수거 요청 시간")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.leading, 16)
                        
                        PickUpTimeView(selectedDate: $selectedDate)
                    } // VStack; 수거 요청 시간
                    
                    NewRequestSelectionView(selectedCategories: $selectedCategories)
                    
                    if !selectedCategories.isEmpty {
                        VStack(spacing: 18) {
                            HStack {
                                Text("품목")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.leading, 16)
                            
                            ForEach(selectedCategories.sorted(), id: \.self) { category in
                                
                                HStack {
                                    Text(category.rawValue)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "1F1F1F"))
                                    Spacer()
                                    
                                    Text("\(getCount(for: category)) 봉투")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.requestAccent)
                                    
                                    GarbageStepper(category: category, count: getCounter(for: category))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 60)
                                        .foregroundStyle(.white)
                                )
                            }
                                
                        } // VStack; 품목
                        
                        Spacer().frame(height: 20)
//                        NavigationLink {
//                            // TODO: 메인화면으로 돌아가기
//                        } label: {
//                            ButtonLabel(
//                                content: "요청하기",
//                                isAgentRequst: true,
//                                isDisabled: selectedCategories.isEmpty
//                            )
//                        }
                        
                        Button {
                            lm.getCoordinateFrom(address: selectedAddress) { coordinate, error in
                                if let error = error {
                                    print("Error:", error)
                                } else if let coordinate = coordinate {
                                    let request = Request(
                                        id: UUID(),
                                        type: .garbageRequest,
                                        address: selectedAddress,
                                        coordinate: coordinate,
                                        garbageType: (selectedCategories.first ?? .plastic).rawValue,
                                        amount: getCount(for: selectedCategories.first ?? .plastic).description,
                                        requestTime: Timestamp(),
                                        preferredPickupTime: Timestamp(date: selectedDate),
                                        status: .requested,
                                        helperId: "shuwn",
                                        description: ""
                                    )
                                    manager.addGarbageRequest(request)
                                    isDone = true
                                } else {
                                    print("No coordinate found")
                                }
                            }
                        } label: {
                            ButtonLabel(
                                content: isDone ? "요청 완료" : "요청하기",
                                isAgentRequst: true,
                                isDisabled: selectedCategories.isEmpty || isDone
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .navigationTitle("새로운 대행 요청")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showAddressSearchSheet) {
            AddressSearchSheetView(
                selectedAddress: $selectedAddress,
                showAddressSearchSheet: $showAddressSearchSheet)
            .presentationDetents([.height(500)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPickRequestAddressSheet) {
            PickRequestAdress(
                selectedAddress: $selectedAddress,
                showPickRequestAddressSheet: $showPickRequestAddressSheet
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private func getCount(for category: GarbageCategory) -> Int {
        switch category {
        case .garbageBag:
            return garbageBagCount
        case .plasticBag:
            return plasticBagCount
        case .can:
            return canCount
        case .bottle:
            return bottleCount
        case .polystyrene:
            return polystyreneCount
        case .plastic:
            return plasticCount
        case .clearPet:
            return clearPetCount
        case .paper:
            return paperCount
        }
    }
    
    
    private func getCounter(for category: GarbageCategory) -> Binding<Int> {
        switch category {
        case .garbageBag:
            return $garbageBagCount
        case .plasticBag:
            return $plasticBagCount
        case .can:
            return $canCount
        case .bottle:
            return $bottleCount
        case .polystyrene:
            return $polystyreneCount
        case .plastic:
            return $plasticCount
        case .clearPet:
            return $clearPetCount
        case .paper:
            return $paperCount
        }
    }

}

enum GarbageCategory: String, Comparable {
    case garbageBag = "종량제"
    case plasticBag = "비닐"
    case can = "캔"
    case bottle = "병류"
    case polystyrene = "스티로폼"
    case plastic = "플라스틱"
    case clearPet = "투명 페트병"
    case paper = "종이"
    
    var order: Int {
        switch self {
        case .garbageBag:
            return 1
        case .plasticBag:
            return 2
        case .can:
            return 3
        case .bottle:
            return 4
        case .polystyrene:
            return 5
        case .plastic:
            return 6
        case .clearPet:
            return 7
        case .paper:
            return 8
        }
    }
    static func < (lhs: GarbageCategory, rhs: GarbageCategory) -> Bool {
        return lhs.order < rhs.order
    }
}

fileprivate struct NewRequestSelectionView: View {
    @Binding var selectedCategories: Set<GarbageCategory>
    
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
        let isSelected = selectedCategories.contains(item)
        
        RoundedRectangle(cornerRadius: 10)
            .fill(isSelected ? .requestAccent : .requestSub)
            .frame(height: 84)
            .overlay(alignment: .topLeading) {
                VStack {
                    HStack {
                        Text(item.rawValue)
                            .fontWeight(.semibold)
                            .font(.system(size: 13))
                            .padding(.leading, 10)
                            .foregroundColor(isSelected ? .white : .black)
                        
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        // TODO: 아이콘 넣기
                        Text("아이콘 이미지")
                            .font(.system(size: 11))
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                            .foregroundColor(isSelected ? .white : .black)
                    }
                }
                .padding(.top, 10)
            }
            .onTapGesture {
                if isSelected {
                    selectedCategories.remove(item)
                } else {
                    selectedCategories.insert(item)
                }
            }
    }
}

fileprivate struct PickUpTimeView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Spacer()
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
            
            Spacer()
            
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 50)
                .foregroundStyle(.white)
        )
    }
}


fileprivate struct GarbageStepper: View {
    let category: GarbageCategory
    @Binding var count: Int

    var body: some View {
        Stepper(value: $count, in: 1...5) {
            Text("\(count)")
        }
        .labelsHidden()
    }
}
#Preview {
    AgentRequestView()
}
