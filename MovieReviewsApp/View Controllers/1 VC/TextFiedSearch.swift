//
//  TextFiedSearch.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 12.04.2022.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchReviews {
            let separeteText = textField.text?.components(separatedBy: " ")
            guard let separeteText = separeteText else { return true }
            let search = StorageData().searchQuery(separatedName: separeteText,
                                                   search: .reviw)
            textField.resignFirstResponder()
            textField.text = nil
            
            //MainViewController().fetchData(url: search)
            guard let url = URL(string: search) else { return true}
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.reviews = try decoder.decode(Review.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.collectionView.reloadData()
                    }
                    print(self.reviews ?? "Error")
                } catch let error {
                    print(error)
                }
            }.resume()
        }
        return true
    }
}
