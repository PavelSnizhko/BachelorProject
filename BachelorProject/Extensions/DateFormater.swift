//
//  DateFormater.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.04.2021.
//

import Foundation

extension DateFormatter {

    public static var pmDateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "MM.dd.yyyy"

        return formatter
    } ()

}
