//
//  HoppittCalendarWidget.swift
//  HoppittCalendarWidget
//
//  Created by Matt Hoppitt on 4/11/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarWidgetEntry {
        CalendarWidgetEntry(date: Date(), events: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarWidgetEntry) -> ()) {
        let entry = CalendarWidgetEntry(date: Date(), events: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let events = await EventsModel().fetchEvents()
            let entry = CalendarWidgetEntry(date: Date(), events: events)
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 15),
                to: Date()
            )!
            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )
            completion(timeline)
        }
    }
}

struct CalendarWidgetEntry: TimelineEntry {
    var date: Date
    let events: [CalendarEvent]
}

@MainActor
class EventsModel: ObservableObject {
    @Published var events: [CalendarEvent]?
    var eventsTable = CalendarEventsTable()

    func fetchEvents() async -> [CalendarEvent] {
        do {
            events = try await eventsTable.getEvents()
        } catch let error {
            print(error)
        }
        return events ?? []
    }
}

struct HoppittCalendarWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            do {
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: entry.date)
                let day = DateFormatter().weekdaySymbols[(calendarDate.weekday ?? 1) - 1].prefix(3)
                let dateNum = calendarDate.day ?? 1
                let month = DateFormatter().monthSymbols[(calendarDate.month ?? 1) - 1].prefix(3)
                
                VStack(alignment: .leading) {
                    HStack() {
                        Text(dateNum.formatted())
                            .bold()
                        Text(day)
                            .textCase(.uppercase)
                    }
                    .font(.system(size: 18))
                    .frame(alignment: .leading)
                    Text(month)
                        .textCase(.uppercase)
                        .font(.system(size: 16))
                }
                VStack(alignment: .leading) {
                    ForEach(entry.events, id: \.id) { event in
                        if (Calendar.current.isDate(event.date, equalTo: entry.date, toGranularity: .day)) {
                            HStack(spacing: 5) {
                                if (event.who == "Matt and Benji") {
                                    HStack(spacing: 0) {
                                        Image(systemName: "m.circle.fill")
                                        Image(systemName: "b.circle.fill")
                                    }
                                } else {
                                    Image(systemName: "\(event.who.prefix(1).lowercased()).circle.fill")
                                }
                                HStack(spacing: 0) {
                                    Text(event.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size: 16))
                                        .multilineTextAlignment(.leading)
                                    Text(event.time.formatted(date: .omitted, time: .shortened))
                                        .textCase(.uppercase)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: 80, alignment: .trailing)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HoppittCalendarWidget: Widget {
    let kind: String = "HoppittCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HoppittCalendarWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HoppittCalendarWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Calendar Widget")
        .description("Displays events for today")
    }
}

#Preview(as: .systemMedium) {
    HoppittCalendarWidget()
} timeline: {
    CalendarWidgetEntry(date: Date(), events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: Date(), time: Date(), who: "Matt", isKeyDate: false), CalendarEvent(id: "15CEC560-004E-4809-88E7-E30EDCB6A7DC", title: "test event dhs shsc hh", date: Date(), time: Date(), who: "Matt and Benji", isKeyDate: false)])
}
