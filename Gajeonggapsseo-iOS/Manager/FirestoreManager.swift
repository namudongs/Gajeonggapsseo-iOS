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
    let db = Firestore.firestore()
    
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
    
    func checkAndUpdateRequestStatus(_ request: Request) -> Request {
        let ref = db.collection("garbageRequests").document(request.id.uuidString)
        
        var updatedRequest = request
        
        ref.getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("Document does not exist")
                return
            }
            
            do {
                let serverRequest = try snapshot.data(as: Request.self)
                
                if serverRequest.status != request.status {
                    // 서버의 문서와 현재 모델의 상태가 다른 경우, 서버 문서로 모델을 업데이트합니다.
                    updatedRequest = serverRequest
                    
                    if let index = self.garbageRequests.firstIndex(where: { $0.id == serverRequest.id }) {
                        // 배열에서 일치하는 요청을 찾아 서버 문서의 데이터로 업데이트합니다.
                        self.garbageRequests[index] = serverRequest
                    }
                }
            } catch {
                print("Error decoding document: \(error)")
            }
        }
        
        return updatedRequest
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
            "type": CenterType.requestInProgress.rawValue,
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
