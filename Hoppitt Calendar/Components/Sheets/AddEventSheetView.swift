//
//  AddEventSheetView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 31/10/2023.
//

import SwiftUI

struct AddEventSheetView: View {
    var type: String
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var toast: Toast? = nil
    @State var eventId: String = ""
    @State var eventTitle: String = ""
    @State var eventDate: Date = Date()
    @State var eventWho = "Matt"
    @State var isKeyDate: Bool = false
    
    let eventWhoList = ["Matt", "Benji", "Matt and Benji"]
    
    let eventsTable = CalendarEventsTable()
    
    var body: some View {
        VStack {
            HStack() {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }.frame(maxWidth: .infinity, alignment: .leading)
                Text("\(type) Event")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                Button(action: {
                    Task {
                        do {
                            if (type == "Add") {
                                let event: CalendarEvent = CalendarEvent(id: eventsTable.generateID(), title: eventTitle, date: eventDate, who: eventWho, isKeyDate: isKeyDate)
                                try await eventsTable.addEvent(event: event)
                            } else {
                                let event: CalendarEvent = CalendarEvent(id: eventId, title: eventTitle, date: eventDate, who: eventWho, isKeyDate: isKeyDate)
                                try await eventsTable.editEvent(event: event)
                            }
                            dismiss()
                        } catch let error {
                            toast = Toast(style: .error, message: "Error", width: 210)
                            print(error)
                        }
                    }
                }) {
                    Text("Save")
                        .bold()
                        .disabled(eventTitle.isEmpty)
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack(spacing: 30) {
                Section() {
                    HStack() {
                        Text("Enter an Event")
                        TextField("Event Title", text: $eventTitle, axis: .vertical)
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, 5)
                    }
                    DatePicker("Select a Date",
                        selection: $eventDate,
                        displayedComponents: .date)
                    DatePicker("Select a Time", selection: $eventDate, displayedComponents: .hourAndMinute)
                    HStack {
                        Text("Select Person")
                        Spacer()
                        Picker(selection: $eventWho, label: Text("Select Person")) {
                            ForEach(eventWhoList, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    Toggle("Key Date", isOn: $isKeyDate)
                    if (type == "Edit") {
                        Button(action: {
                            Task {
                                do {
                                    let event: CalendarEvent = CalendarEvent(id: eventId, title: eventTitle, date: eventDate, who: eventWho, isKeyDate: isKeyDate)
                                    try await eventsTable.deleteEvent(event: event)
                                    dismiss()
                                } catch let error {
                                    toast = Toast(style: .error, message: "Error", width: 210)
                                    print(error)
                                }
                            }
                        }) {
                            Text("Delete Event")
                                .frame(maxWidth: .infinity, maxHeight: 30)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }.padding()
            Spacer()
        }
        .toastView(toast: $toast)
        .padding()
        .padding(.top, 20)
        .preferredColorScheme(colorScheme)
    }
}

#Preview {
    AddEventSheetView(type: "Add")
}
