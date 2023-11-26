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
    var eventsToday: [CalendarEvent] = []

    func fetchEvents() async -> [CalendarEvent] {
        do {
            events = try await eventsTable.getEvents()
            for event in events.unsafelyUnwrapped {
                if (Calendar.current.isDate(event.startDate, equalTo: Date(), toGranularity: .day) || Calendar.current.isDate(event.endDate, equalTo: Date(), toGranularity: .day) || ((event.startDate ... event.endDate).contains(Date()))) {
                    eventsToday.append(event)
                }
            }
        } catch let error {
            print(error)
        }
        return eventsToday
    }
}

struct HoppittCalendarWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 0) {
            do {
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: entry.date)
                let day = DateFormatter().weekdaySymbols[(calendarDate.weekday ?? 1) - 1]
                let dateNum = calendarDate.day ?? 1
                let month = DateFormatter().monthSymbols[(calendarDate.month ?? 1) - 1].prefix(3)
                
                Text("\(String(day)) \(dateNum.formatted()) \(String(month))")
                    .font(.system(size: 18))
                    .textCase(.uppercase)
                    .bold()
                    .padding(.bottom, 1)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 2) {
                    if (entry.events.isEmpty) {
                        Text("No events today")
                    } else {
                        ForEach(entry.events, id: \.id) { event in
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
                                    // One date and one time
                                    if (!event.hasEndDate && Calendar.current.isDate(event.startDate, equalTo: entry.date, toGranularity: .day)) {
                                        Text(event.startDate.formatted(date: .omitted, time: .shortened))
                                            .font(.system(size: 15))
                                            .frame(alignment: .trailing)
                                            .padding(.leading, 5)
                                    }
                                    // One date and two times
                                    else if (event.hasEndDate && Calendar.current.isDate(event.startDate, equalTo: event.endDate, toGranularity: .day) &&  Calendar.current.isDate(event.endDate, equalTo: entry.date, toGranularity: .day)) {
                                        VStack {
                                            Text(event.startDate.formatted(date: .omitted, time: .shortened))
                                                .font(.system(size: 15))
                                                .frame(alignment: .trailing)
                                                .padding(.leading, 5)
                                            Text(event.endDate.formatted(date: .omitted, time: .shortened))
                                                .font(.system(size: 15))
                                                .frame(alignment: .trailing)
                                                .padding(.leading, 5)
                                        }
                                    }
                                    // Two separate dates
                                    else {
                                        // Start date
                                        if (Calendar.current.isDate(event.startDate, equalTo: entry.date, toGranularity: .day)) {
                                            Text("Starts \(event.startDate.formatted(date: .omitted, time: .shortened))")
                                                .font(.system(size: 15))
                                                .frame(alignment: .trailing)
                                                .padding(.leading, 5)
                                        }
                                        // End date
                                        else if (Calendar.current.isDate(event.endDate, equalTo: entry.date, toGranularity: .day)) {
                                            Text("Ends \(event.endDate.formatted(date: .omitted, time: .shortened))")
                                                .font(.system(size: 15))
                                                .frame(alignment: .trailing)
                                                .padding(.leading, 5)
                                        }
                                        // Middle date
                                        else {
                                            Text("all-day")
                                                .font(.system(size: 15))
                                                .frame(alignment: .trailing)
                                                .padding(.leading, 5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
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
    CalendarWidgetEntry(date: Date(), events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", hasEndDate: true, startDate: Date(), endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(), who: "Matt", isKeyDate: false), CalendarEvent(id: "15CEC560-004E-4809-88E7-E30EDCB6A7DC", title: "test event dhs shsc hh ghd jj", hasEndDate: true, startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), who: "Matt and Benji", isKeyDate: false)])
}
