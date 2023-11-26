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
    @Binding var refreshed: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            do {
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: date)
                let day = DateFormatter().weekdaySymbols[(calendarDate.weekday ?? 1) - 1]
                let dateNum = calendarDate.day ?? 1
                let month = DateFormatter().monthSymbols[(calendarDate.month ?? 1) - 1].prefix(3)
                
                Text("\(String(day)) \(dateNum.formatted()) \(String(month))")
                    .font(.system(size: 18))
                    .textCase(.uppercase)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    ForEach(events, id: \.id) { event in
                        Button(action: {
                            isPresentingEvent = event
                            showingSheet.toggle()
                        }) {
                            if (Calendar.current.isDate(event.startDate, equalTo: date, toGranularity: .day) || Calendar.current.isDate(event.endDate, equalTo: date, toGranularity: .day) || ((event.startDate ... event.endDate).contains(date))) {
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
                                            .multilineTextAlignment(.leading)
                                        // One date and one time
                                        if (!event.hasEndDate && Calendar.current.isDate(event.startDate, equalTo: date, toGranularity: .day)) {
                                            Text(event.startDate.formatted(date: .omitted, time: .shortened))
                                                .font(.system(size: 15))
                                                .frame(alignment: .trailing)
                                                .padding(.leading, 5)
                                        }
                                        // One date and two times
                                        else if (event.hasEndDate && Calendar.current.isDate(event.startDate, equalTo: event.endDate, toGranularity: .day) &&  Calendar.current.isDate(event.endDate, equalTo: date, toGranularity: .day)) {
                                            VStack(spacing: 0) {
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
                                            if (Calendar.current.isDate(event.startDate, equalTo: date, toGranularity: .day)) {
                                                Text("Starts \(event.startDate.formatted(date: .omitted, time: .shortened))")
                                                    .font(.system(size: 15))
                                                    .frame(alignment: .trailing)
                                                    .padding(.leading, 5)
                                            }
                                            // End date
                                            else if (Calendar.current.isDate(event.endDate, equalTo: date, toGranularity: .day)) {
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
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                    .sheet(item: $isPresentingEvent, onDismiss: {
                        self.refreshed.toggle()
                    }) { event in
                        AddEventSheetView(type: "Edit", eventId: event.id, eventTitle: event.title, hasEndDate: event.hasEndDate, eventStartDate: event.startDate, eventEndDate: event.endDate, eventWho: event.who, isKeyDate: event.isKeyDate)
                    }
                }
                .padding(.top, 5)
                .padding(.leading)
                .padding(.trailing)
            }
            Divider()
                .overlay(.gray)
                .padding(.top, 20)
        }
        .padding(.bottom)
    }
}

struct CalendarView_Preview: PreviewProvider {
  static var previews: some View {
      CalendarView(events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", hasEndDate: false, startDate: Date(), endDate: Date(), who: "Matt", isKeyDate: false), CalendarEvent(id: "15CEC560-004E-4809-88E7-E30EDCB6A7DC", title: "test event dhs shsc hh", hasEndDate: false, startDate: Date(), endDate: Date(), who: "Matt and Benji", isKeyDate: false)], date: Date(), refreshed: .constant(true))
  }
}

#Preview {
    CalendarView_Preview.previews
}
