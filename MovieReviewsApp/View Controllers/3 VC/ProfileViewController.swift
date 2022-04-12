//
//  ProfileViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 11.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var criticProfile: Critics?
    private var criticReview: Review?
    private var criticProfileReviewJsonUrl: String {
        let name = nameForSearch?.components(separatedBy: " ")
        // TODO: ЗАГЛУШКА!
        guard let name = name else { return "ЗАГЛУШКА TODO!"}
        print(cahgeUrl(separatedName: name, reviewSearch: true))
        return cahgeUrl(separatedName: name, reviewSearch: true)
    }
    private var criticProfileInfoJsonUrl: String {
        configureSearchQuery()
    }
    
    var nameForSearch: String?
    
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var nameCritic: UILabel!
    @IBOutlet var statusCritic: UILabel!
    @IBOutlet var bioCritic: UILabel!
    @IBOutlet var headerReviewList: UILabel!
    @IBOutlet var collectionProfile: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataCritic()
        fetchDataReview()
    }
   

    private func configureSearchQuery(reviewSearch: Bool =  false) -> String {
        let name = self.nameForSearch
        // TODO: ЗАГЛУШКА!
        guard let name = name else { return "ЗАГЛУШКА TODO!"}
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
        
        return cahgeUrl(separatedName: separatedName, reviewSearch: reviewSearch)
    }
    
    private func cahgeUrl(separatedName: [String], reviewSearch : Bool) -> String {
        
        var result = ""
        for searchStr in separatedName  {
            let tag = "%20"
            
            if searchStr == separatedName.last {
                result += searchStr
            } else {
                result += searchStr + tag
            }
        }
        
        let responce = "https://api.nytimes.com/svc/movies/v2/critics/\(result).json?api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        let responceReview = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?reviewer=\(result)&api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
        return reviewSearch ? responceReview : responce
    }
    
    private func configureProfile() {
        let result = criticProfile?.results?[0]
        nameCritic.text = nameForSearch
        statusCritic.text = result?.status
        bioCritic.text = result?.bio
        headerReviewList.text = result?.displayName
    }
    
    func fetchDataCritic() {
        guard let url = URL(string: criticProfileInfoJsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.criticProfile = try decoder.decode(Critics.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.configureProfile()
                    self.collectionProfile.reloadData()
                }
                print(self.criticProfile ?? "Error")
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchDataReview() {
        guard let url = URL(string: criticProfileReviewJsonUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.criticReview = try decoder.decode(Review.self, from: data)
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    self.collectionView.reloadData()
//                }
                print(self.criticReview ?? "Error")
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
//        guard let review = reviews?.results?[indexPath.row] else { return cell }
//
//        cell.configure(with: review, index: indexPath)
//
//        // Interact with button for Progile Critic
//        cell.criticProfile.tag = indexPath.row
//        cell.criticProfile.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
//
//        // Alert
//        cell.onMoreInfoTap = { [weak self] alert in
//            self?.present(alert, animated: true)
//            self?.present(MainViewController(), animated: true, completion: nil)
//        }
        
        return cell
    }
    
    
}
