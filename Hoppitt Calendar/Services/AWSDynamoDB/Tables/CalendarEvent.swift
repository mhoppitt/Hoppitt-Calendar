//
//  CalendarEvent.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import Foundation

public struct CalendarEvent: Codable {
    var id: String
    var title: String
    var date: Date
    var who: String
    
    init(id: String, title: String, date: Date, who: String) {
        self.id = id
        self.title = title
        self.date = date
        self.who = who
    }
}
