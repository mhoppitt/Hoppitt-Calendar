//
//  CalendarView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

struct CalendarView: View {
    var event: CalendarEvent
    
    var body: some View {
        HStack {
            Text(event.title)
            Spacer()
            Text(event.date)
        }
        .padding()
    }
}

#Preview {
    CalendarView(event: CalendarEvent(id: "15CEC567-004E-4809-88E7-E30EDCB6A7DC", title: "test event", date: "123"))
}
