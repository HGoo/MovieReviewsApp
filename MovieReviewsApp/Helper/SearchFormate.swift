//
//  DateFormate.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 13.04.2022.
//

import Foundation
import UIKit


final class Edit {
    
    static let shared = Edit()
    
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
        guard let string = nameForSearch else { return ""}
        
        return StorageData().searchQuery(nameForSearch: string, search: search)
    }
}
