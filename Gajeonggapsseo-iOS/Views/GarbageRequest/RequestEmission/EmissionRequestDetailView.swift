//
//  EmissionRequestDetailView.swift
//  Gajeonggapsseo-iOS
//
//  Created by Damin on 6/26/24.
//

import SwiftUI
import CoreLocation

struct EmissionRequestDetailView: View {
    @State private var selectedCategories: [GarbageCategory: Int] = [.bottle:0, .can: 1, .clearPet: 2]
    @State private var memoText: String = ""
    @State private var selectedAddress: String = "대잠동"
    @EnvironmentObject var locationManager: LocationManager
    
    private let backgroundColor: Color = Color(hex: "F2F7FF")
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(.all)
            
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 28) {
                    EmissionPlaceView(selectedAddress: $selectedAddress, locationManager: locationManager)
                    PickUpTimeView()
                    CategoryCountView(selectedCategories: $selectedCategories)
                    EmissionMemoView(memoText: $memoText)
                }
                .padding(.horizontal, 27)
                .padding(.top, 34)
            }
            
        }
        //        .toolbarBackground(Color.gray, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("요청하기")
    }
    
}

fileprivate struct EmissionPlaceView: View {
    @Binding var selectedAddress: String
    @ObservedObject var locationManager: LocationManager
    
    @State private var showAddressSearch = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("배출 장소")
                .font(.headline)
            HStack {
                TextField("주소를 선택하세요", text: $selectedAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true)
                Button("검색") {
                    showAddressSearch.toggle()
                }
            }
            
            Button(action: {
                fetchCurrentLocationAddress()
            }) {
                Text("현재 위치 찾기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showAddressSearch) {
            AddressSearchView(selectedAddress: $selectedAddress)
        }
    }
    
    private func fetchCurrentLocationAddress() {
        if let location = locationManager.currentLocation {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding failed: \(error.localizedDescription)")
                } else if let placemarks = placemarks, let placemark = placemarks.first {
                    selectedAddress = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.country].compactMap { $0 }.joined(separator: ", ")
                    print("디버그", selectedAddress)
                }
            }
        }
    }
}

fileprivate struct PickUpTimeView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("수거 요청 시간")
                .font(.headline)
            
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
        }
    }
}

fileprivate struct CategoryCountView: View {
    @Binding var selectedCategories: [GarbageCategory: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("품목")
                .font(.headline)
            
            ForEach(Array(selectedCategories.keys), id: \.self) { category in
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    Button(action: {
                        if let count = selectedCategories[category], count > 0 {
                            selectedCategories[category] = count - 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                    }
                    Text("\(selectedCategories[category, default: 0])개")
                    Button(action: {
                        if let count = selectedCategories[category] {
                            selectedCategories[category] = count + 1
                        } else {
                            selectedCategories[category] = 1
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}

fileprivate struct EmissionMemoView: View {
    @Binding var memoText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("기타 메모")
                .font(.headline)
            TextEditor(text: $memoText)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .background(Color(hex: "F2F7FF"))
        }
    }
}

#Preview {
    NavigationStack {
        EmissionRequestDetailView()
    }
}
