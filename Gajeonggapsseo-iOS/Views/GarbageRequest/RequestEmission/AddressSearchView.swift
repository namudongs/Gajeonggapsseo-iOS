//
//  AddressSearchView.swift
//  Gajeonggapsseo-iOS
//
//  Created by Damin on 6/27/24.
//

import MapKit
import SwiftUI

struct AddressSearchView: View {
    @Binding var selectedAddress: String
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        VStack {
            TextField("주소를 입력하세요", text: $searchQuery, onCommit: {
                performSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
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
        }
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
    AddressSearchView(selectedAddress: .constant("대잠동LocationManager"))
}
