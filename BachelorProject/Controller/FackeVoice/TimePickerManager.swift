//
//  TimePickerManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 01.04.2021.
//

import UIKit


// TODO: make abstraction with protocols for both managers

//protocol PickerManagerProtocol: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    var selectedItem: ItemClosure
//}

class TimePickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedTime: Int?
    
    private let pickerDataSource = [5, 10, 20, 30, 40, 60, 80]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let time = pickerDataSource[row]
        self.selectedTime = time
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerDataSource[row])"
        
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerDataSource[row]
        let myTitle = NSAttributedString(string: "\(titleData)",
                                         attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 20.0)!,
                                                      NSAttributedString.Key.foregroundColor:UIColor.black])
        return myTitle
    }
}
