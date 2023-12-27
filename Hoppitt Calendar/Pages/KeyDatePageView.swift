//
//  KeyDatePageView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

@MainActor
class KeyDateModel: ObservableObject {
    @Published var events: [CalendarEvent]?
    var eventsTable = CalendarEventsTable()

    init() {}

    func fetchEvents() async {
        do {
            events = try await eventsTable.getEvents()
            Task {
                try await eventsTable.cleanupTable(events: events ?? [])
            }
        } catch let error {
            print(error)
        }
    }
}

struct KeyDatePageView: View {
    @StateObject var model = KeyDateModel()
    @State public var refreshed: Bool = false
    @State public var monthList: [Date] = []
    @State private var showingSpinner: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    func refreshView() {
        return refreshed.toggle()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Spacer()
                Text("Key Dates")
                    .font(.title)
                    .bold()
                Spacer()
            }.padding(.bottom, 10)
            ScrollView {
                ForEach(monthList, id: \.hashValue) { date in
                    KeyDateView(events: model.events ?? [], date: date, refreshed: $refreshed)
                }
            }
            .refreshable {
                refreshView()
            }
            .task(id: refreshed) {
                await model.fetchEvents()
                monthList = DateService().getThreeMonthsFromToday()
                showingSpinner = false
            }
        }
        .overlay(
            GeometryReader() { proxy in
                ZStack {
                    if (showingSpinner) {
                        ProgressView()
                            .scaleEffect(2.0)
                    }
                }.offset(x: proxy.size.width / 2, y: proxy.size.height / 2)
            }
        )
    }
}

#Preview {
    KeyDatePageView()
}
