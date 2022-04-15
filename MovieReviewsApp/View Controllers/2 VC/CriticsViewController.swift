//
//  CriticsViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class CriticsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var collectionViewCritics: UICollectionView!
    
    // MARK: - Private Properties
    private let criticsJsonUrl = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
    private var critics: Critics?
    private let searchController = UISearchController(searchResultsController: nil)
    private var searching = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewCritics.delegate = self
        collectionViewCritics.dataSource = self
        
        fetchData()
        configureSearchController()
    }
    
    // MARK: - Methods
    func fetchData() {
        guard let url = URL(string: criticsJsonUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.critics = try decoder.decode(Critics.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.collectionViewCritics.reloadData()
                    //
                }
                print(self.critics ?? "Error review")
            } catch let error {
                print(error)
            }
        }.resume()
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

extension CriticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return critics?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCritics", for: indexPath) as! CriticViewCell
        guard let critic = critics?.results?[indexPath.row] else { return cell }
        
        cell.configureCritic(with: critic)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profile.nameForSearch = critics?.results?[indexPath.row].displayName
        self.navigationController?.pushViewController(profile, animated: true )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size.width / 2
        return CGSize(width: size - 30, height: size + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

extension CriticsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        if !(searchText?.isEmpty)! {
            searching = false
        } else {
            searching = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        collectionViewCritics.reloadData()
    }
    
}
