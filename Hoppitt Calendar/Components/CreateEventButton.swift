//
//  CreateEventButton.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import SwiftUI

struct CreateEventButton: View {
    @State private var toast: Toast? = nil
    
    var body: some View {
        Button(action: {
            Task {
                let eventsTable = CalendarEventsTable()
                let event: CalendarEvent = CalendarEvent(id: eventsTable.generateID(), title: "TEST EVENT", date: Date(), who: "Matt")
                do {
                    try await eventsTable.addEvent(event: event)
                    toast = Toast(style: .success, message: "Event saved", width: 190)
                } catch let error {
                    toast = Toast(style: .error, message: "Error", width: 190)
                    print(error)
                }
            }
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
        }
        .toastView(toast: $toast)
    }
}

#Preview {
    CreateEventButton()
}
