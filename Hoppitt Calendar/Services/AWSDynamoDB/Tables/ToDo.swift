//
//  ToDoItem.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 6/11/2023.
//

import Foundation

public struct ToDo: Codable, Identifiable, Hashable, Equatable {
    public var id: String
    var title: String
    var date: Date
    var who: String
    var isCompleted: Bool
    
    init(id: String, title: String, date: Date, who: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.who = who
        self.isCompleted = isCompleted
    }
}
