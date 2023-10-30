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
    
    var body: some View {
        HStack() {
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
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(events, id: \.id) { event in
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
                                Text(event.title)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .opacity(Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: Date()) ? 0.5 : 1.0)
        Divider()
    }
}

#Preview {
    CalendarView(events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: Date(), who: "Matt"), CalendarEvent(id: "15CEC560-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: Date(), who: "Matt and Benji")], date: Date())
}
