////
////  GarbagegRequestView.swift
////  Gajeonggapsseo-iOS
////
////  Created by namdghyun on 6/18/24.
////
//
//import SwiftUI
//import FirebaseFirestore
//import CoreLocation
//
//struct GarbageRequestView: View {
//    @EnvironmentObject var locationManager: LocationManager
//    @EnvironmentObject var manager: FirestoreManager
//    
//    @State private var geopoint: CLLocationCoordinate2D?
//    @State private var garbageType: String = ""
//    @State private var amount: String = ""
//    @State private var preferredPickupTime: Date = Date()
//    @State private var userId: String = "requestedUser" // 사용자 ID
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("배출 위치")) {
//                    Text("\(locationManager.currentPlace)")
//                    NavigationLink {
//                        PickRequestAdress()
//                    } label: {
//                        Text("위치 선택하기")
//                    }.buttonStyle(.bordered)
//
//                }
//                
//                Section(header: Text("쓰레기 종류")) {
//                    TextField("쓰레기 종류 입력", text: $garbageType)
//                }
//                
//                Section(header: Text("쓰레기의 양")) {
//                    TextField("쓰레기의 양 입력", text: $amount)
//                }
//                
//                Section(header: Text("배출 예정 시간")) {
//                    DatePicker("배출 예정 시간 선택", selection: $preferredPickupTime, displayedComponents: .date)
//                }
//                
//                Button(action: submitRequest) {
//                    Text("배출 요청하기")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//            .navigationBarTitle("배출 요청하기")
//        }
//    }
//    
//    func submitRequest() {
//        let newRequest = Request(id: UUID(),
//                                 type: .garbageRequest,
//                                 address: locationManager.currentPlace,
//                                 coordinate: CLLocationCoordinate2D(latitude: locationManager.currentGeoPoint?.latitude ?? 0.0,
//                                                                    longitude: locationManager.currentGeoPoint?.longitude ?? 0.0),
//                                 garbageType: garbageType,
//                                 amount: amount,
//                                 requestTime: Timestamp(date: Date()),
//                                 preferredPickupTime: Timestamp(date: preferredPickupTime),
//                                 status: .requested,
//                                 helperId: "Helper ID",
//                                 description: ""
//        )
//        
//        manager.addGarbageRequest(newRequest)
//    }
//}
//
