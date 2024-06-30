//
//  AddressSearchSheetView.swift
//  Gajeonggapsseo-iOS
//
//  Created by Damin on 6/27/24.
//

import MapKit
import SwiftUI

struct AddressSearchSheetView: View {
    @Binding var selectedAddress: String
    @Binding var showAddressSearchSheet: Bool
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("주소를 입력하세요", text: $searchQuery, onCommit: {
                    performSearch()
                })
                .foregroundColor(.primary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                if !searchQuery.isEmpty {
                    Button(action: {
                        self.searchQuery = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color(.systemGray6))
            .cornerRadius(10.0)
            
            
            
            List(searchResults, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name ?? "")
                    Text(item.placemark.title ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    if let name = item.name, let title = item.placemark.title {
                        selectedAddress = "\(name), \(title)"
                    }
                }
            }
            .padding(.horizontal, -20)
        }
        .padding(20)
        .onAppear(perform: {
            searchQuery = selectedAddress
        })
    }
    
    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            searchResults = response.mapItems
        }
    }
}
#Preview {
    AddressSearchSheetView(
        selectedAddress: .constant("대잠동"),
        showAddressSearchSheet: .constant(true))
}
