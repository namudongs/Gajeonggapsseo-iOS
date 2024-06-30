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
                    RequestSheetView(sheetPresent: $sheetPresent, center: request)
                }
            }
        }
    }
}
