//
//  CustomAlertController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 01.04.2021.
//

import UIKit

class CustomAlertController<T>: UIAlertController {
    var dataFromPockerView: ItemClosure<T>?
}
