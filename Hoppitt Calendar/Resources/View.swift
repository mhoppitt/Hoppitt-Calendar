//
//  View.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

extension View {

    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
