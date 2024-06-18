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
    @Published var title: String = ""
    @Published var name: String = ""
    
    init () {
        fetchData()
    }
    
    func fetchData() {
        let db = Firestore.firestore()
        let docRef = db.collection("freeboard").document("abcabc")
        docRef.getDocument { (document, error) in
            guard error == nil else { return print(error!.localizedDescription) }
            let data = document?.data()
            if let data = data {
                self.title = data["title"] as? String ?? "데이터가 없습니다."
                self.name = data["name"] as? String ?? "데이터가 없습니다."
            }
        }
    }
}
