//
//  CreateEventButton.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import SwiftUI

struct CreateEventButton: View {
    var body: some View {
        Button(action: {
            Task {
                let eventsTable = CalendarEventsTable()
                let event: CalendarEvent = CalendarEvent(id: eventsTable.generateID(), title: "test event", date: "123")
                do {
                    try await eventsTable.addEvent(event: event)
                } catch let error {
                    print(error)
                }
            }
        }) {
            Text("Create Event")
        }
    }
}

#Preview {
    CreateEventButton()
}
