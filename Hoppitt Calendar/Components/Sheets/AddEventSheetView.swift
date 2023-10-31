//
//  AddEventSheetView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 31/10/2023.
//

import SwiftUI

struct AddEventSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var toast: Toast? = nil
    @State private var hasTimeElapsed = false
    
    var body: some View {
        VStack {
            HStack() {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }.frame(maxWidth: .infinity, alignment: .leading)
                Text("Add Event")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                Button(action: {
                    Task {
                        let eventsTable = CalendarEventsTable()
                        let event: CalendarEvent = CalendarEvent(id: eventsTable.generateID(), title: "TEST EVENT", date: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date(), who: "Matt")
                        do {
                            try await eventsTable.addEvent(event: event)
                            dismiss()
                        } catch let error {
                            toast = Toast(style: .error, message: "Error", width: 210)
                            print(error)
                        }
                    }
                }) {
                    Text("Save")
                        .bold()
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            Spacer()
        }
        .toastView(toast: $toast)
        .padding()
    }
}

#Preview {
    AddEventSheetView()
}
