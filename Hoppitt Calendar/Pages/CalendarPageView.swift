//
//  CalendarPageView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import SwiftUI

@MainActor
class EventsModel: ObservableObject {
    @Published var events: [CalendarEvent]?
    var eventsTable = CalendarEventsTable()

    init() {}

    func fetchEvents() async {
        do {
            events = try await eventsTable.getEvents()
        } catch let error {
            print(error)
        }
    }
}

struct CalendarPageView: View {
    @State private var contentSize: CGSize = .zero
    @StateObject var model = EventsModel()
    @State public var refreshed: Bool = false
    
    func refreshView() {
        return refreshed.toggle()
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                Text("Calendar")
                    .font(.title)
                    .bold()
                VStack(alignment: .leading) {
                    ForEach(model.events ?? [], id: \.id) { result in
                        CalendarView(event: result)
                    }
                }
            }
        }
        .refreshable {
            refreshView()
        }
        .task(id: refreshed) {
            await model.fetchEvents()
        }
        .overlay(
            GeometryReader() { proxy in
                ZStack {
                    CreateEventButton()
                }
                .offset(x: 160, y: (proxy.size.height / 2) - 40)
            }
        )
    }
}

#Preview {
    CalendarPageView()
}
