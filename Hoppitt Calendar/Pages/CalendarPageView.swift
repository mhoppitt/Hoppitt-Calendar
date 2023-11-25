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
            Task {
                try await eventsTable.cleanupTable(events: events ?? [])
            }
        } catch let error {
            print(error)
        }
    }
}

struct CalendarPageView: View {
    @StateObject var model = EventsModel()
    @State public var refreshed: Bool = false
    @State public var dateList: [Date] = []
    @State private var showingSheet = false
    @State private var showingSpinner: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    func refreshView() {
        return refreshed.toggle()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Text("")
                    .frame(width: 40) // element with equal width of button to centre heading
                    .padding(.leading)
                Spacer()
                Text("Calendar")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.trailing)
                }
                .sheet(isPresented: $showingSheet, onDismiss: {
                    refreshView()
                }) {
                    AddEventSheetView(type: "Add")
                }
            }.padding(.bottom, 10)
            ScrollView {
                ForEach(dateList, id: \.hashValue) { date in
                    CalendarView(events: model.events ?? [], date: date, refreshed: $refreshed)
                }
            }
            .refreshable {
                refreshView()
            }
            .task(id: refreshed) {
                await model.fetchEvents()
                dateList = DateService().getFortnightFromToday()
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
    CalendarPageView()
}
