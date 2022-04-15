//
//  CriticsViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class CriticsViewController: UIViewController {
    @IBOutlet var collectionViewCritics: UICollectionView!
    
    private let criticsJsonUrl = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
    private var critics: Critics?
    private var criticsSorted: [ResultCritic]?
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewCritics.delegate = self
        collectionViewCritics.dataSource = self
        
        fetchData()
        configureSearchController()
    }
    
    private func fetchData() {
        NetworkDataFetch.shared.fetchCritics(urlString: criticsJsonUrl) { [weak self] criticModel, error in
            guard let self = self else { return }
            if error == nil {
                
                guard let criticModel = criticModel?.results else { return }
                
                if criticModel != [] {
                    let sortedCritic = criticModel.sorted { firstItem, secondItem in
                        return firstItem.displayName?.compare((secondItem.displayName)!) == ComparisonResult.orderedAscending
                    }
                    self.criticsSorted = sortedCritic
                    self.collectionViewCritics.reloadData()
                } else {
                    //
                }
                
                //                guard let criticModel = criticModel else { return }
                //                self.critics = criticModel
                //                self.collectionViewCritics.reloadData()
                //            } else {
                //                print(error!.localizedDescription)
                //
                            }
            }
        }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search "
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension CriticsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return criticsSorted?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCritics", for: indexPath) as! CriticViewCell
        guard let critic = criticsSorted?[indexPath.row] else { return cell }
        
        cell.configureCritic(with: critic)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size.width / 2
        return CGSize(width: size - 30, height: size + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
    
//MARK: - UICollectionViewDelegate

extension CriticsViewController: UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profile.nameForSearch = criticsSorted?[indexPath.row].displayName
        self.navigationController?.pushViewController(profile, animated: true )
    }
}

//MARK: - UISearchResultsUpdating, UISearchControllerDelegate

extension CriticsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        
        if !searchText.isEmpty {
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionViewCritics.reloadData()
    }
}

