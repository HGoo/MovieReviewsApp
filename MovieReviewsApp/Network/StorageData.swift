//
//  ReviewImage.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class StorageData {
    func fetchCachImage(with url: String?, imageView: UIImageView, _ completion: @escaping (UIImage) -> ()) {
        guard let url = url else { return }
        guard let imageUrl = url.getURL() else {
            imageView.image = UIImage(named: "notFound")
            return
        }
        
        if let cachedImage = self.getCachedImage(url: imageUrl) {
            completion(cachedImage)
            return
        }
        
        fetchImage(url: imageUrl, url, completion)
    }
    
    func fetchImage(url imageUrl: URL, _ url: String, _ completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error { print(error); return }
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else {  return }
            if responseURL.absoluteString != url { return }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                completion(image)
            }
            self.saveImageToCache(data: data, response: response)
        }.resume()
    }
    
    func saveImageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    func getCachedImage(url: URL) -> UIImage? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}

fileprivate extension String{
    func getURL() -> URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
}
