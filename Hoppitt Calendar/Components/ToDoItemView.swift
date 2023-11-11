//
//  ToDoItem.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 6/11/2023.
//

import SwiftUI

struct ToDoItemView: View {
    var todoList: [ToDo]
    var selectedWho: String
    
    @Binding var refreshed: Bool
    
    let todoTable = ToDoTable()
    
    var body: some View {
        ForEach(todoList, id: \.id) { todo in
            if todo.who == selectedWho {
                HStack {
                    Button(action: {
                        Task {
                            do {
                                let todoItem: ToDo = ToDo(id: todo.id, title: todo.title, date: todo.date, who: todo.who, isCompleted: !todo.isCompleted)
                                try await todoTable.editToDoItem(todo: todoItem)
                                self.refreshed.toggle()
                            }
                        }
                    }) {
                        todo.isCompleted ? Image(systemName: "checkmark.circle.fill").foregroundColor(.red).scaleEffect(1.2) : Image(systemName: "checkmark.circle").foregroundColor(.red).scaleEffect(1.2)
                    }
                    Text("\(todo.title)")
                }
                .swipeActions {
                    Button(role: .destructive) {
                        Task {
                            do {
                                try await todoTable.deleteToDoItem(todo: todo)
                                self.refreshed.toggle()
                            }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}

#Preview {
    ToDoItemView(todoList: [ToDo(id: "123", title: "A list item", date: Date(), who: "Matt", isCompleted: true), ToDo(id: "1234", title: "A second list item", date: Date(), who: "Matt", isCompleted: false), ToDo(id: "12345", title: "A third list item A third list item A third list item A third list item", date: Date(), who: "Benji", isCompleted: false)], selectedWho: "Matt", refreshed: .constant(true))
}
