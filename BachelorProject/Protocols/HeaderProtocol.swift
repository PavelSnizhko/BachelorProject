//
//  HeaderProtocol.swift
//  BachelorProject
//
//  Created by Павел Снижко on 04.03.2021.
//

import Foundation

protocol HeaderProtocol {
    associatedtype CellType
    
    var cellModel: [CellType] { get }
}
