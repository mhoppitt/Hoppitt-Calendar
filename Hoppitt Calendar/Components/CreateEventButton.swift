//
//  TestView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import SwiftUI

struct CreateEventButton: View {
    var body: some View {
        Button(action: {
            Task {
                let event: CalendarEvent = CalendarEvent(title: "test event", date: "123")
                let eventsTable = CalendarEventsTable()
                try await eventsTable.addEvent(event: event)
            }
        }) {
            Text("Create Event")
        }
    }
}

#Preview {
    CreateEventButton()
}
