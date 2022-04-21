//
//  ProfileViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 11.04.2022.
//

import UIKit


class ProfileViewController: UIViewController {
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var nameCritic: UILabel!
    @IBOutlet var statusCritic: UILabel!
    @IBOutlet var bioCritic: UILabel!
    @IBOutlet var collectionProfile: UICollectionView!
    
    private var criticProfile: Critics?
    private var criticReview: Review?
    private var criticProfileJsonUrl: String {
        guard let name = criticName else { return ""}
        return Edit.shared.searchQuery(nameForSearch: name, link: .critic)
    }
    private var criticReviewJsonUrl: String {
        guard let name = criticName else { return ""}
        return Edit.shared.searchQuery(nameForSearch: name, link: .profile)
    }
    private var isPaginating = false
    private var offSet = 0

    var criticName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionProfile.delegate = self
        collectionProfile.dataSource = self
        fetchDataCritic()
        fetchDataReview()
    }
    
    private func fetchDataCritic() {
        
        NetworkDataFetch.shared.fetchCritics(urlString: criticProfileJsonUrl) { [weak self] criticModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let criticModel = criticModel else { return }
                self.criticProfile = criticModel
                self.configureProfile()
                self.collectionProfile.reloadData()
                print(criticModel,"    ", self.criticProfileJsonUrl)
            } else {
                print(error!.localizedDescription)
                
            }
        }
    }
    
    private func fetchDataReview() {
        
        NetworkDataFetch.shared.fetchReview(urlString: criticReviewJsonUrl) { [weak self] reviewModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let reviewModel = reviewModel else { return }
                self.criticReview = reviewModel
                self.collectionProfile.reloadData()
                print(reviewModel,"    ", self.criticReviewJsonUrl)
            } else {
                print(error!.localizedDescription)
                
            }
        }
    }
    
    private func configureProfile() {
        
        let result = criticProfile?.results?[0]
        nameCritic.text = criticName
        statusCritic.text = result?.status
        bioCritic.text = result?.bio
        
        
        if result?.multimedia?.resource?.src == nil {
            imageProfile.image = UIImage(named: "personIcon")
            return
        }
        
        StorageData().fetchCachImage(with: result?.multimedia?.resource?.src,
                                     imageView: imageProfile) { image in
            self.imageProfile.image = image
        }
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

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
        profile.criticName = criticReview?.results?[indexPath.row].byline
        self.navigationController?.pushViewController(profile, animated: true )
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 30, height: 390)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        if position > (collectionProfile.contentSize.height - 100 - scrollView.frame.size.height) {
            
            guard !isPaginating else { return }
            isPaginating = true
            offSet += 20
            
            let url = Edit.shared.searchQuery(with: offSet, nameForSearch: criticName ?? "",
                                              link: .profile)
           
            
            
            NetworkDataFetch.shared.fetchReview(urlString: url) { [weak self] reviewModel, error in
                guard let self = self else { return }
                if error == nil {
                    guard let reviewModel = reviewModel?.results else { return }
                    
                    self.criticReview?.results?.append(contentsOf: reviewModel)
                    self.collectionProfile.reloadData()
                    
                    self.isPaginating = false
                } else {
                    print(error!.localizedDescription)
                    self.isPaginating = false
                    self.offSet = 0
                }
            }
        }
    }
}

