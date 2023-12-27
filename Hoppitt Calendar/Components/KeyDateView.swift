//
//  KeyDateView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/12/2023.
//

import SwiftUI

struct KeyDateView: View {
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
                let month = DateFormatter().monthSymbols[(calendarDate.month ?? 1) - 1]
                
                Text("\(String(month))")
                    .font(.system(size: 22))
                    .textCase(.uppercase)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(events, id: \.id) { event in
                        Button(action: {
                            isPresentingEvent = event
                            showingSheet.toggle()
                        }) {
                            if (event.isKeyDate && (Calendar.current.isDate(event.startDate, equalTo: date, toGranularity: .month) || Calendar.current.isDate(event.endDate, equalTo: date, toGranularity: .month) || ((event.startDate ... event.endDate).contains(date)))) {
                                let eventStartDay = event.startDate.formatted(date: .complete, time: .omitted).components(separatedBy: ",")[0].prefix(3)
                                let eventStartDate = event.startDate.formatted(date: .complete, time: .omitted).components(separatedBy: ",")[1].components(separatedBy: " ")[1]
                                let eventStartMonth = event.startDate.formatted(date: .complete, time: .omitted).components(separatedBy: ",")[1].components(separatedBy: " ")[2].prefix(3)
                                let eventEndDay = event.endDate.formatted(date: .complete, time: .omitted).components(separatedBy: ",")[0].prefix(3)
                                let eventEndDate = event.endDate.formatted(date: .complete, time: .omitted).components(separatedBy: ",")[1].components(separatedBy: " ")[1]
                                let eventEndMonth = event.endDate.formatted(date: .complete, time: .omitted).components(separatedBy: ",")[1].components(separatedBy: " ")[2].prefix(3)
                                VStack(spacing: 0) {
                                    HStack() {
                                        // One date
                                        if (Calendar.current.isDate(event.startDate, equalTo: event.endDate, toGranularity: .day)) {
                                            Text("\(String(eventStartDay)) \(String(eventStartDate)) \(String(eventStartMonth))")
                                        }
                                        // Two dates
                                        else {
                                            if (Calendar.current.isDate(event.startDate, equalTo: event.endDate, toGranularity: .month)) {
                                                Text("\(String(eventStartDay)) \(String(eventStartDate)) - \(String(eventEndDay)) \(String(eventEndDate)) \(String(eventEndMonth))")
                                            } else {
                                                Text("\(String(eventStartDay)) \(String(eventStartDate)) \(String(eventStartMonth)) - \(String(eventEndDay)) \(String(eventEndDate)) \(String(eventEndMonth))")
                                            }
                                        }
                                        Spacer()
                                    }
                                    HStack(spacing: 5) {
                                        if (event.who == "Matt and Benji") {
                                            HStack(spacing: 0) {
                                                Image(systemName: "m.circle.fill")
                                                Image(systemName: "b.circle.fill")
                                            }.padding(.bottom, 10)
                                        } else {
                                            Image(systemName: "\(event.who.prefix(1).lowercased()).circle.fill")
                                                .padding(.bottom, 10)
                                        }
                                        Text(event.title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                            .padding(.bottom, 10)
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

struct KeyDateView_Preview: PreviewProvider {
  static var previews: some View {
      KeyDateView(events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", hasEndDate: true, startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(), who: "Matt", isKeyDate: true), CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DL", title: "test", hasEndDate: true, startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), who: "Matt", isKeyDate: true), CalendarEvent(id: "15CEC560-004E-4809-88E7-E30EDCB6A7DC", title: "test event dhs shsc hh", hasEndDate: false, startDate: Date(), endDate: Date(), who: "Matt and Benji", isKeyDate: true)], date: Date(), refreshed: .constant(true))
  }
}

#Preview {
    KeyDateView_Preview.previews
}
