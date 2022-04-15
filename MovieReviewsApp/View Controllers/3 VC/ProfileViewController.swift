//
//  ProfileViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 11.04.2022.
//

import UIKit


class ProfileViewController: UIViewController {
   // MARK: - IBOutlets
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var nameCritic: UILabel!
    @IBOutlet var statusCritic: UILabel!
    @IBOutlet var bioCritic: UILabel!
    @IBOutlet var collectionProfile: UICollectionView!
    
    // MARK: - Private Properties
    private var criticProfile: Critics?
    private var criticReview: Review?
    private var criticProfileReviewJsonUrl: String {
        guard let name = nameForSearch?.components(separatedBy: " ") else { return ""}
       
        return StorageData().searchQuery(separatedName: name, search: .critic)
    }
    private var criticReviewJsonUrl: String {
        guard let name = nameForSearch?.components(separatedBy: " ") else { return ""}
       
        return StorageData().searchQuery(separatedName: name, search: .profile)
    }

    
    var nameForSearch: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionProfile.delegate = self
        collectionProfile.dataSource = self
        
        fetchDataCritic()
        fetchDataReview()
        print(criticReviewJsonUrl)
    }
   
    // MARK: - Private Methods
    private func fetchDataCritic() {
        guard let url = URL(string: criticProfileReviewJsonUrl) else { return }
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
    
    private func fetchDataReview() {
        guard let url = URL(string: criticReviewJsonUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.criticReview = try decoder.decode(Review.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.collectionProfile.reloadData()
                }
                print(self.criticReview ?? "Error")
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    private func configureProfile() {
        let result = criticProfile?.results?[0]
        if result?.multimedia?.resource?.src == nil {
            imageProfile.image = UIImage(named: "personIcon")
        }
        nameCritic.text = nameForSearch
        statusCritic.text = result?.status
        bioCritic.text = result?.bio
        
        StorageData().fetchCachImage(with: result?.multimedia?.resource?.src,
                                     imageView: imageProfile) { image in
            self.imageProfile.image = image
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return criticReview?.results?.count ?? 0
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellProfile", for: indexPath) as! ProfileViewCell
       
        guard let criticReview = criticReview?.results?[indexPath.row] else { return cell }
        
        cell.configure(with: criticReview, index: indexPath)
        // Alert
        cell.onMoreInfoTap = { [weak self] alert in
            self?.present(alert, animated: true)
            self?.present(MainViewController(), animated: true, completion: nil)
        }
        
        return cell
    }
    
    @objc func viewProfile(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profile.nameForSearch = criticReview?.results?[indexPath.row].byline
        self.navigationController?.pushViewController(profile, animated: true )
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 30, height: 390)
    }
}

