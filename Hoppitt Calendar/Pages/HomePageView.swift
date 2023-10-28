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
            Image("Calendar")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(CONSTANTS.COLOURS.GREY)
            Text("Hello, world!")
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
