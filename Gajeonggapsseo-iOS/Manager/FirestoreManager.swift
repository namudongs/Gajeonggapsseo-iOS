//
//  FirebaseManager.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/18/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// MARK: - 파이어스토어 데이터를 관리하는 매니저
class FirestoreManager: ObservableObject {
    @Published var garbageRequests: [Request] = []
    @Published var selectedRequest: Request?
    let db = Firestore.firestore()
    private var selectedRequestListener: ListenerRegistration?
    
    // MARK: - 불러오기
    func listenToGarbageRequests() {
            db.collection("garbageRequests").addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("배출 요청 불러오기 실패: \(error)")
                } else {
                    self.garbageRequests = snapshot?.documents.compactMap {
                        try? $0.data(as: Request.self)
                    } ?? []
                }
            }
        }
    
    func listenToSelectedRequest(_ requestId: String) {
            let requestRef = db.collection("garbageRequests").document(requestId)
            
            selectedRequestListener = requestRef.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("선택된 요청 불러오기 실패: \(error)")
                } else if let snapshot = snapshot, snapshot.exists {
                    self.selectedRequest = try? snapshot.data(as: Request.self)
                } else {
                    self.selectedRequest = nil
                }
            }
        }
        
        func stopListeningToSelectedRequest() {
            selectedRequestListener?.remove()
            selectedRequestListener = nil
        }
    
    // MARK: - 요청, 수락, 픽업, 완료 플로우
    func addGarbageRequest(_ request: Request) {
        do {
            let requestRef = db.collection("garbageRequests").document(request.id.uuidString)
            try requestRef.setData(from: request)
            print("배출 요청이 성공적으로 등록되었습니다.")
        } catch let error {
            print("배출 요청 생성 실패: \(error)")
        }
    }
    
    func acceptGarbageRequest(_ requestId: String, helperId: String) {
        let requestRef = db.collection("garbageRequests").document(requestId)
        let updateData: [String: String] = [
            "status": RequestStatus.accepted.rawValue
        ]
        
        requestRef.updateData(updateData) { error in
            if let error = error { print("배출 요청 수락 실패: \(error)") }
            else { print("배출 요청이 성공적으로 수락되었습니다.") }
        }
    }
    
    func pickUpGarbageRequest(_ requestId: String) {
        let requestRef = db.collection("garbageRequests").document(requestId)
        let updateData: [String: String] = [
            "status": RequestStatus.pickedUp.rawValue
        ]
        
        requestRef.updateData(updateData) { error in
            if let error = error { print("배출 요청 픽업 실패: \(error)") }
            else { print("배출 요청 요청데이터 업데이트가 성공했습니다.") }
        }
    }
    
    func completeGarbageRequest(_ requestId: String) {
        let requestRef = db.collection("garbageRequests").document(requestId)
        let updateData: [String: String] = [
            "status": RequestStatus.completed.rawValue
        ]
        
        requestRef.updateData(updateData) { error in
            if let error = error { print("배출 요청 픽업 실패: \(error)") }
            else { print("배출 요청 요청데이터 업데이트가 성공했습니다.") }
        }
    }
}
