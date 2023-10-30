//
//  Hoppitt_CalendarApp.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import SwiftUI

@main
struct Hoppitt_CalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppLayout()
                
                GeometryReader { reader in
                    Color.white
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea()
                }
            }
            .zIndex(100000)
        }
    }
}
