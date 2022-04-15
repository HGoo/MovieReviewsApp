//
//  DateFormate.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 13.04.2022.
//

import Foundation
import UIKit

enum Target {
    case critic
    case profile
    case reviw
    case date
}

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
    
    func searchQuery(nameForSearch: String, search: Target) -> String {
        
        let nameForSearch = nameForSearch.components(separatedBy: " ")
        var result = ""
        
        for searchStr in nameForSearch  {
            let tag = "%20"
            if searchStr == nameForSearch.last {
                result += searchStr
            } else {
                result += searchStr + tag
            }
        }
        
        switch search {
        case .critic:
            return "https://api.nytimes.com/svc/movies/v2/critics/\(result).json?api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        case .profile:
            return "https://api.nytimes.com/svc/movies/v2/reviews/search.json?reviewer=\(result)&api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        case .reviw:
            return "https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=\(result)&api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        case .date:
            return "https://api.nytimes.com/svc/movies/v2/reviews/search.json?publication-date=\(result)&api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        }
        
    }
}
