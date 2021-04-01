//
//  PickerManager.swift
//  BachelorProject
//
//  Created by Павел Снижко on 01.04.2021.
//

import UIKit


class LanguagePickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedLanguage: String?
    
    private let pickerDataSource = ["Ukrainian", "Russian", "English"]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let language = pickerDataSource[row]
        selectedLanguage = language
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
        
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerDataSource[row]
        let myTitle = NSAttributedString(string: titleData,
                                         attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 20.0)!,
                                                      NSAttributedString.Key.foregroundColor:UIColor.black])
        return myTitle
    }
}
