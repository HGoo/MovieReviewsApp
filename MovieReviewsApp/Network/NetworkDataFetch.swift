//
//  NetworkDataFetch.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 15.04.2022.
//

import Foundation


class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    
    private init() {
        
    }
    
    func fetchReview(urlString: String, responce: @escaping (Review?, Error?) -> Void) {
        NetworkRequest.shared.requestData(urlString: urlString) { data in
            
            switch data {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let review = try decoder.decode(Review.self, from: data)
                    responce(review, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
                
            case .failure(let error):
                print("Error received reuesting data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
    
    func fetchCritics(urlString: String, responce: @escaping (Critics?, Error?) -> Void) {
        NetworkRequest.shared.requestData(urlString: urlString) { data in
            
            switch data {
            case .success(let data):
                do {
                    let critics = try JSONDecoder().decode(Critics.self, from: data)
                    responce(critics, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
                
            case .failure(let error):
                print("Error received reuesting data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }

}
