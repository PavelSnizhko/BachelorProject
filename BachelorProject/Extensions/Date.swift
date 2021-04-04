//
//  Date.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import Foundation

extension Date {

    func stringed(using dateFormatter: DateFormatter) -> String {
        return dateFormatter.string(from: self)
    }

    static func withoutTimeStamp() -> Date {

           let date = Date()
           let interestedComponents: Set<Calendar.Component> = [.year, .month, .day]
           let dateComponents = Calendar.current.dateComponents(interestedComponents,
                                                                from: date)

           guard let dateWithoutTimeStamp = Calendar.current.date(from: dateComponents) else {
               return date
           }

           return dateWithoutTimeStamp
       }
}
