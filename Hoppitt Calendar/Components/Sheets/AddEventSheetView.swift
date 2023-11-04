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
    @State private var toast: Toast? = nil
    @State var eventTitle: String = ""
    @State var eventDate: Date = Date()
    @State var eventTime: Date = Date()
    @State var eventWho = "Matt"
    @State var isKeyDate: Bool = false
    
    let eventWhoList = ["Matt", "Benji", "Matt and Benji"]
    
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
                        let eventsTable = CalendarEventsTable()
                        let event: CalendarEvent = CalendarEvent(id: eventsTable.generateID(), title: eventTitle, date: eventDate, time: eventTime, who: eventWho, isKeyDate: isKeyDate)
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
                        .disabled(eventTitle.isEmpty)
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack(spacing: 30) {
                Section() {
                    HStack() {
                        Text("Enter an Event")
                        TextField("Event Title", text: $eventTitle)
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, 5)
                    }
                    DatePicker("Select a Date",
                        selection: $eventDate,
                        displayedComponents: .date)
                    DatePicker("Select a Time", selection: $eventTime, displayedComponents: .hourAndMinute)
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
                }
            }.padding()
            Spacer()
        }
        .toastView(toast: $toast)
        .padding()
        .padding(.top, 20)
    }
}

#Preview {
    AddEventSheetView(type: "Add")
}
