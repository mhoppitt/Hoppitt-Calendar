//
//  ContentView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack {
            Text("Calendar")
                .font(.title)
                .bold()
            CreateEventButton()
        }
        .padding()
    }
}

#Preview {
    HomePageView()
}
