//
//  CalendarEvent.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import Foundation

public struct CalendarEvent: Codable, Identifiable {
    public var id: String
    var title: String
    var date: Date
    var time: Date
    var who: String
    var isKeyDate: Bool
    
    init(id: String, title: String, date: Date, time: Date, who: String, isKeyDate: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.time = time
        self.who = who
        self.isKeyDate = isKeyDate
    }
}
