//
//  MainViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var searchReviews: UITextField!
    
    var reviews: Review?
    
    // MARK: - Private Properties
    
    private let refreshControl = UIRefreshControl()
    private var reviewsJsonUrl = "https://api.nytimes.com/svc/movies/v2/reviews/all.json?api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchReviews.delegate = self
        collectionView.alwaysBounceVertical = true
        
        fetchData(url: reviewsJsonUrl)
        pullTorefresh()
        hideKeyboard()
    }
    
    // MARK: - Private Methods
    private func fetchData(url: String) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.reviews = try decoder.decode(Review.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                    
                }
                print(self.reviews ?? "Error")
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    private func hideKeyboard() {
        let tapScreen = UITapGestureRecognizer(target: self,
                                               action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
    private func pullTorefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        fetchData(url: reviewsJsonUrl)
        refreshControl.endRefreshing()
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func changeDate() {
        let dateSearch = Edit().configureDate(toString: datePicker)
        
        let urlSerach = StorageData().searchQuery(nameForSearch: dateSearch,
                                                  search: .date)
        fetchData(url: urlSerach)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewViewCell
        guard let review = reviews?.results?[indexPath.row] else { return cell }
        
        cell.configure(with: review, index: indexPath)
        
        // Interact with button for Progile Critic
        cell.criticProfile.tag = indexPath.row
        cell.criticProfile.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        
        // Alert
        cell.onMoreInfoTap = { [weak self] alert in
            guard let self = self else { return }
            self.present(alert, animated: true)
            self.present(MainViewController(), animated: true, completion: nil)
        }
        return cell
    }
    
    // Tap on name critick
    @objc func viewProfile(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profile.nameForSearch = reviews?.results?[indexPath.row].byline
        self.navigationController?.pushViewController(profile, animated: true )
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 30, height: 400)
    }
}



