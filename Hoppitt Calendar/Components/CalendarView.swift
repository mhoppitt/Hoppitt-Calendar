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
        HStack {
            do {
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: date)
                let day = DateFormatter().weekdaySymbols[(calendarDate.weekday ?? 1) - 1].prefix(3)
                let date = calendarDate.day ?? 1
                let month = DateFormatter().monthSymbols[(calendarDate.month ?? 1) - 1].prefix(3)
                
                Text(day)
                    .textCase(.uppercase)
                Text(date.formatted())
                Text(month)
                    .textCase(.uppercase)
                Spacer()
                VStack {
                    ForEach(events, id: \.id) { event in
                        Text(event.title)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    CalendarView(events: [CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: "123"), CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: "123")], date: Date())
}
