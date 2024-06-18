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
                print("Error getting documents: \(error)")
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
        } catch let error {
            print("Error adding document: \(error)")
        }
    }
}
