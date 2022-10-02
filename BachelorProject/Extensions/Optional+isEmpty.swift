//
//  Optional+isEmpty.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 01.10.2022.
//

import Foundation

extension Optional where Wrapped == String {
    var isEmpty: Bool {
        (self ?? "").isEmpty
    }
}
