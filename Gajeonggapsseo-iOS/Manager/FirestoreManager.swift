//
//  FirebaseManager.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    @Published var garbageRequests = [GarbageRequest]()
    @Published var title: String = ""
    @Published var name: String = ""
    let db = Firestore.firestore()
    
    init () {
        fetchGarbageRequests()
    }
    
    func fetchGarbageRequests() {
        let db = Firestore.firestore()
        db.collection("garbageRequests").getDocuments { (snapshot, error) in
            if let error = error {
                print("배출 요청 불러오기 실패: \(error)")
            } else {
                self.garbageRequests = snapshot?.documents.compactMap {
                    try? $0.data(as: GarbageRequest.self)
                } ?? []
            }
        }
    }
    
    func addGarbageRequest(_ request: GarbageRequest) {
        do {
            let _ = try db.collection("garbageRequests").addDocument(from: request)
            print("배출 요청이 성공적으로 등록되었습니다.")
        } catch let error {
            print("배출 요청 생성 실패: \(error)")
        }
    }
}
