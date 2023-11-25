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
            if let day = Calendar.current.date(byAdding: .day, value: i, to: Date()) {
                week += [day]
            }
        }
        return week
    }
}
