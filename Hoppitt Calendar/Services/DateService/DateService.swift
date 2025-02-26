//
//  DateService.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 29/10/2023.
//

import Foundation

public class DateService {
    func getFortnightFromToday() -> [Date] {
        var week = [Date]()
        for i in 0...13 {
            if let day = Calendar.current.date(byAdding: .day, value: i, to: Calendar.current.startOfDay(for: Date())) {
                week += [day]
            }
        }
        return week
    }
    
    func getThreeMonthsFromToday() -> [Date] {
        var threeMonths = [Date]()
        for i in 0...2 {
            if let month = Calendar.current.date(byAdding: .month, value: i, to: Calendar.current.startOfDay(for: Date())) {
                threeMonths += [month]
            }
        }
        return threeMonths
    }
}
