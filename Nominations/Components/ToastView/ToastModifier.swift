//
//  ToastModifier.swift
//  Nominations
//
//  Created by cabbage on 2023/10/27.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: ToastModel?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }
                    .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { _, _ in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast {
            VStack {
                Spacer()
                ToastView(message: toast.message) {
                    dismissToast()
                }
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
               dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(_ toast: Binding<ToastModel?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
