//
//  CustomSheet.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/30/24.
//

import SwiftUI

struct CustomSheetView: View {
    @Binding var sheetPresent: Bool
    @Binding var selectedCenter: (any Center)?
    @Binding var navigateAcceptanceData: (Request?, Bool)
    @Binding var navigateProgressData: (Request?, Bool)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
            
            if selectedCenter is JejuClean || selectedCenter is SeogwipoClean {
                CleanHouseSheetView(sheetPresent: $sheetPresent, center: selectedCenter)
            }
            if selectedCenter is JejuRecycle || selectedCenter is SeogwipoRecycle {
                if let jejyRecycle = selectedCenter as? JejuRecycle {
                    JejuRecycleSheetView(sheetPresent: $sheetPresent, center: jejyRecycle)
                }
                if let seogwipoRecycle = selectedCenter as? SeogwipoRecycle {
                    SeogwipoRecycleSheetView(sheetPresent: $sheetPresent, center: seogwipoRecycle)
                }
            }
            if selectedCenter is Request {
                if let request = selectedCenter as? Request {
                    if request.status == .requested {
                        RequestSheetView(sheetPresent: $sheetPresent, navigateAcceptanceData: $navigateAcceptanceData, center: request)
                    } else {
                        AcceptedRequestSheetView(sheetPresent: $sheetPresent, navigateProgressData: $navigateProgressData, center: request)
                    }
                }
            }
        }
    }
}
