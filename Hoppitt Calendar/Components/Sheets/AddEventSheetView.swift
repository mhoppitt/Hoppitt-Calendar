//
//  AddEventSheetView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 31/10/2023.
//

import SwiftUI

struct AddEventSheetView: View {
    var type: String
    
    enum FocusField: Hashable {
        case field, none
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var toast: Toast? = nil
    @State var eventId: String = ""
    @State var eventTitle: String = ""
    @State var eventDate: Date = Date()
    @State var eventWho = "Matt"
    @State var isKeyDate: Bool = false
    
    @State var showsStartsDatePicker = false
    @State var showsStartsDateTimePicker = false
    @State var showsEndsDatePicker = false
    @State var showsEndsDateTimePicker = false
    
    @FocusState private var focusedField: FocusField?
    @State private var profileSegmentIndex = 0
    
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
            Form() {
                Section() {
                    HStack() {
                        TextField(
                            "Event Title",
                            text: $eventTitle,
                            onCommit: { self.focusedField = Optional.none }
                        )
                        .padding(.trailing, 5)
                        .focused($focusedField, equals: .field)
                        .onAppear {
                            if (type != "Edit") {
                                self.focusedField = .field
                            }
                        }
                    }
                    HStack {
                        Picker(selection: $eventWho, label: Text("Select Person")) {
                            ForEach(eventWhoList, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                Section() {
                    HStack {
                        Text("Starts")
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showsStartsDateTimePicker = false
                                showsEndsDateTimePicker = false
                                showsEndsDatePicker = false
                                showsStartsDatePicker.toggle()
                            }
                        }) {
                            Text(eventDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(showsStartsDatePicker ? .red : colorScheme == .dark ? .white : .black)
                        Button(action: {
                            withAnimation {
                                showsStartsDatePicker = false
                                showsEndsDateTimePicker = false
                                showsEndsDatePicker = false
                                showsStartsDateTimePicker.toggle()
                            }
                        }) {
                            Text(eventDate.formatted(date: .omitted, time: .shortened))
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(showsStartsDateTimePicker ? .red : colorScheme == .dark ? .white : .black)
                    }
                    if (showsStartsDatePicker) {
                        DatePicker("Starts",
                                   selection: $eventDate,
                                   displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    if (showsStartsDateTimePicker) {
                        DatePicker("Starts",
                                   selection: $eventDate,
                                   displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                    HStack {
                        Text("Ends")
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showsStartsDateTimePicker = false
                                showsStartsDatePicker = false
                                showsEndsDateTimePicker = false
                                showsEndsDatePicker.toggle()
                            }
                        }) {
                            Text(eventDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(showsEndsDatePicker ? .red : colorScheme == .dark ? .white : .black)
                        Button(action: {
                            withAnimation {
                                showsStartsDateTimePicker = false
                                showsStartsDatePicker = false
                                showsEndsDatePicker = false
                                showsEndsDateTimePicker.toggle()
                            }
                        }) {
                            Text(eventDate.formatted(date: .omitted, time: .shortened))
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(showsEndsDateTimePicker ? .red : colorScheme == .dark ? .white : .black)
                    }
                    if (showsEndsDatePicker) {
                        DatePicker("Ends",
                                   selection: $eventDate,
                                   displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    if (showsEndsDateTimePicker) {
                        DatePicker("Ends",
                                   selection: $eventDate,
                                   displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                }
                Section() {
                    Toggle("Key Date", isOn: $isKeyDate)
                }
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
                    .listRowInsets(EdgeInsets())
                    .background(Color(UIColor.systemGroupedBackground))
                }
            }
            .padding(-16)
            .onTapGesture {
                self.focusedField = Optional.none
            }
            Spacer()
        }
        .toastView(toast: $toast)
        .padding()
        .padding(.top, 20)
        .background(colorScheme == .dark ? SwiftUI.Color.init(red: 0.11, green: 0.11, blue: 0.11) : SwiftUI.Color.init(red: 0.95, green: 0.95, blue: 0.97))
        .preferredColorScheme(colorScheme)
    }
}

#Preview {
    AddEventSheetView(type: "Edit")
}
