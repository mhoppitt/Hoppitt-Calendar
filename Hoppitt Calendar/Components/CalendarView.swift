//
//  CalendarView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

struct CalendarView: View {
    var events: [CalendarEvent]
    var date: Date
    
    @State private var showingSheet = false
    @State private var isPresentingEvent: CalendarEvent? = nil
    
    var body: some View {
        HStack {
            do {
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: date)
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
                    .font(.system(size: 22))
                    .frame(width: 90, alignment: .leading)
                    Text(month)
                        .textCase(.uppercase)
                }
                VStack(alignment: .leading) {
                    ForEach(events, id: \.id) { event in
                        Button(action: {
                            isPresentingEvent = event
                            showingSheet.toggle()
                        }) {
                            if (Calendar.current.isDate(event.date, equalTo: date, toGranularity: .day)) {
                                HStack(spacing: 10) {
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
                                            .multilineTextAlignment(.leading)
                                        Text(event.time.formatted(date: .omitted, time: .shortened))
                                            .textCase(.uppercase)
                                            .frame(maxWidth: 80, alignment: .trailing)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 2)
                        .foregroundStyle(.black)
                    }
                    .sheet(item: $isPresentingEvent, onDismiss: {
//                        refreshView()
                    }) { event in
                        AddEventSheetView(type: "Edit", eventId: event.id, eventTitle: event.title, eventDate: event.date, eventTime: event.time, eventWho: event.who, isKeyDate: event.isKeyDate)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .opacity(Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: Date()) ? 0.3 : 1.0)
        Divider()
    }
}

#Preview {
    CalendarView(events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: Date(), time: Date(), who: "Matt", isKeyDate: false), CalendarEvent(id: "15CEC560-004E-4809-88E7-E30EDCB6A7DC", title: "test event dhs shsc hh", date: Date(), time: Date(), who: "Matt and Benji", isKeyDate: false)], date: Date())
}
