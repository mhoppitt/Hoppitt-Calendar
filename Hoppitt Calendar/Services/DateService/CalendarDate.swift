//
//  CalendarDate.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 29/10/2023.
//

import Foundation

public struct CalendarDate: Codable {
    var day: String
    var date: Int
    var month: String
    
    init(day: String, date: Int, month: String) {
        self.day = day
        self.date = date
        self.month = month
    }
}
