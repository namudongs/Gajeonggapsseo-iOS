//
//  Extensions.swift
//  Gajeonggapsseo-iOS
//
//  Created by namdghyun on 6/27/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .hidden,
        sheetCornerRadius: CGFloat?,
        isTransparentBG: Bool = true,
        interactiveDisabled: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> ()
    ) -> some View {
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                if #available(iOS 16.4, *) {
                    content()
                        .presentationDetents([.height(230)])
                        .presentationDragIndicator(dragIndicator)
                        .interactiveDismissDisabled(interactiveDisabled)
                        .presentationCornerRadius(sheetCornerRadius)
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(230)))
                        .presentationBackground(.clear)
                } else {
                    content()
                        .presentationDetents([.height(230)])
                        .presentationDragIndicator(dragIndicator)
                        .interactiveDismissDisabled(interactiveDisabled)
                        .onAppear {
                            guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                                return
                            }
                            
                            if let controller = windows.windows.first?.rootViewController?.presentedViewController,
                               let sheet = controller.presentationController as? UISheetPresentationController {
                                controller.view.backgroundColor = .clear
                                controller.presentingViewController?.view.tintAdjustmentMode = .normal
                                
                                let customDetent = UISheetPresentationController.Detent.custom { _ in
                                    return 230
                                }
                                sheet.detents = [customDetent]
                                sheet.largestUndimmedDetentIdentifier = customDetent.identifier
                                sheet.preferredCornerRadius = sheetCornerRadius
                                
                                // 시트 크기 조절 비활성화
                                sheet.prefersGrabberVisible = false
                                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                                sheet.prefersEdgeAttachedInCompactHeight = true
                                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                            } else {
                                print("NO CONTROLLER FOUND")
                            }
                        }
                }
            }
    }
}
