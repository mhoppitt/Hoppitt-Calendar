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
    var hasEndDate: Bool
    var startDate: Date
    var endDate: Date
    var who: String
    var isKeyDate: Bool
    var isOutForDinner: Bool
    
    init(id: String, title: String, hasEndDate: Bool, startDate: Date, endDate: Date, who: String, isKeyDate: Bool, isOutForDinner: Bool) {
        self.id = id
        self.title = title
        self.hasEndDate = hasEndDate
        self.startDate = startDate
        self.endDate = endDate
        self.who = who
        self.isKeyDate = isKeyDate
        self.isOutForDinner = isOutForDinner
    }
}
