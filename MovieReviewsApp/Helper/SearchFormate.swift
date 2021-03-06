//
//  DateFormate.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 13.04.2022.
//

import UIKit

enum Target {
    case critic
    case profile
    case reviw
    case date
    case pagination
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
    
    func searchQuery(with offSet: Int = 0, nameForSearch: String, link: Target) -> String {
        
        let prefix = "https://api.nytimes.com/svc/movies/v2/"
        let apiKey = "api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        
        
        switch link {
        case .critic:
            return "\(prefix)critics/\(nameForSearch).json?\(apiKey)".addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
        case .profile:
            return "\(prefix)reviews/search.json?offset=\(offSet)&reviewer=\(nameForSearch)&\(apiKey)".addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
        case .reviw:
            return "\(prefix)reviews/search.json?offset=\(offSet)&query=\(nameForSearch)&\(apiKey)".addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
        case .date:
            return "\(prefix)reviews/search.json?publication-date=\(nameForSearch)&\(apiKey)"
        case .pagination:
            return "\(prefix)reviews/all.json?offset=\(offSet)&\(apiKey)"
        }
    }
}
