//
//  DateService.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 29/10/2023.
//

import Foundation

public class DateService {
    func getCurrentWeek() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start on Monday
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...13 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
}
