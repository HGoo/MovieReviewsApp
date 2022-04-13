//
//  DateFormate.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 13.04.2022.
//

import Foundation
import UIKit


final class Edit {
    func cutDate(date: String?) -> String {
        let name = date
        guard let name = name else { return "0000-00-00 00:00:00"}
        let endIndex = name.index(name.endIndex, offsetBy: -4)
        let dateCuted = name[...endIndex]
        let date = String(dateCuted)
        return date
    }
    
    func configureDate(toString datePicker: UIDatePicker) -> String {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        return "\(selectedDate)%3A\(selectedDate)"
    }
    
    func configureSearchQuery(search: Target = .critic, _ nameForSearch: String? ) -> String {
        let name = nameForSearch
        guard let name = name else { return ""}
        var nameWithSpace = ""
        var separatedName = name.components(separatedBy: " ")
        var count = 0
        var countspase = 0
        
        for i in name {
            if i == "." { count += 1 }
            if i == " " { countspase += 1 }
        }
        
        if count > 1, countspase != count {
            count -= 1
            for i in name {
                nameWithSpace.append(i)
                if count > 0, i == "." {
                    nameWithSpace.append(" ")
                    count -= 1
                }
            }
            separatedName = nameWithSpace.components(separatedBy: " ")
        }
        return StorageData().searchQuery(separatedName: separatedName, search: search)
    }
}
