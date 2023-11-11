//
//  ToDoPageView.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

import SwiftUI

@MainActor
class ToDoModel: ObservableObject {
    @Published var todoList: [ToDo]?
    let todoTable = ToDoTable()

    init() {}

    func fetchToDoList() async {
        do {
            todoList = try await todoTable.getToDoList()
        } catch let error {
            print(error)
        }
    }
}

struct ToDoPageView: View {
    @StateObject var model = ToDoModel()
    @State private var refreshed: Bool = false
    @State private var selectedWho = "Matt"
    @State private var newItem = ""
    
    var todoWhoList = ["Matt", "Benji"]
    
    let todoTable = ToDoTable()
    
    func refreshView() {
        return refreshed.toggle()
    }
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .font: UIFont.systemFont(ofSize: 18),
            ], for: .normal
        )
    }
    
    var body: some View {
        VStack() {
            Text("To Do")
                .font(.title)
                .bold()
            VStack {
                Picker(selection: $selectedWho, label: Text("Select Person")) {
                    ForEach(todoWhoList, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                Section(header: Spacer(minLength: 0)) {
                    List {
                        ToDoItemView(todoList: model.todoList ?? [], selectedWho: selectedWho, refreshed: $refreshed)
                        HStack {
                            Image(systemName: "checkmark.circle").foregroundColor(.red).scaleEffect(1.2)
                            TextField("Enter another item", text: $newItem)
                                .onSubmit {
                                    Task {
                                        let todo: ToDo = ToDo(id: todoTable.generateID(), title: newItem, date: Date(), who: selectedWho, isCompleted: false)
                                        try await todoTable.addToDo(todo: todo)
                                        newItem = ""
                                        refreshView()
                                    }
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                    .padding(.top)
                    .refreshable{
                        refreshView()
                    }
                    .task(id: refreshed) {
                         await model.fetchToDoList()
                    }
                }
            }
        }
    }
}

#Preview {
    ToDoPageView()
}
