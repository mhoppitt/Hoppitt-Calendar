//
//  AppLayout.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

struct AppLayout: View {
    var body: some View {
        TabView {
            Group {
                CalendarPageView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                KeyDatePageView()
                    .tabItem {
                        Label("Key Dates", systemImage: "calendar.badge.exclamationmark")
                    }
//                ToDoPageView()
//                    .tabItem {
//                        Label("To Do", systemImage: "checklist")
//                    }
            }
            .toolbarBackground(Color.black, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    AppLayout()
        .environment(\.colorScheme, .dark)
}
