//
//  ToastModifier.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

struct ToastModifier: ViewModifier {
  
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
  
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                GeometryReader() { proxy in
                    ZStack {
                        mainToastView()
                            .offset(x: 0, y: 0)
                    }
                    .animation(.spring(), value: toast)
                    .offset(x: (proxy.size.width / 2) - (210 / 2), y: proxy.size.height - 70)
                }
            )
            .onChange(of: toast) {
                showToast()
            }
    }
  
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                ) {
                    dismissToast()
                }
            }
        }
    }
  
    private func showToast() {
        guard let toast = toast else { return }
    
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    
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
