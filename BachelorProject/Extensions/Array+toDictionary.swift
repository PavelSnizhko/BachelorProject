//
//  Array+toDictionary.swift
//  BachelorProject
//
//  Created by Павел Снижко on 13.10.2022.
//

import Foundation

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
