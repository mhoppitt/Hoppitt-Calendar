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
    @State public var dateList: [Date] = []
    
    func refreshView() {
        return refreshed.toggle()
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                Text("Calendar")
                    .font(.title)
                    .bold()
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(dateList, id: \.hashValue) { date in
                        CalendarView(events: model.events ?? [], date: date)
                    }
                    .overlay(
                        HStack {
                            Divider()
                                .overlay(.black)
                                .offset(x: -100)
                        }
                    )
                }
            }
        }
        .refreshable {
            refreshView()
        }
        .task(id: refreshed) {
            await model.fetchEvents()
            dateList = DateService().getCurrentWeek()
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
