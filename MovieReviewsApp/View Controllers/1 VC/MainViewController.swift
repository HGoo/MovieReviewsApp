//
//  MainViewController.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var searchReviews: UITextField!
   
    private let refreshControl = UIRefreshControl()
    private var reviewsJsonUrl = "https://api.nytimes.com/svc/movies/v2/reviews/all.json?api-key=GW5a0tJfWOcfQ7k3dpQizIsrmpZ33Bmm"
    var reviews: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchReviews.delegate = self
        collectionView.alwaysBounceVertical = true
        
        fetchData(url: reviewsJsonUrl)
        pullTorefresh()
        hideKeyboard()
        
        searchReviews.layer.cornerRadius = 30
    }
    
     func fetchData(url: String) {
        NetworkDataFetch.shared.fetchReview(urlString: url) { [weak self] reviewModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let reviewModel = reviewModel else { return }
                self.reviews = reviewModel
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
                print(reviewModel)
            } else {
                print(error!.localizedDescription)
                
            }
        }
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
    
    @IBAction func changeDate() {
        let dateSearch = Edit.shared.configureDate(toString: datePicker)
    
        let urlSerach = Edit.shared.searchQuery(nameForSearch: dateSearch,
                                                  search: .date)
        fetchData(url: urlSerach)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

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

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchReviews {
            
            guard let separeteText = textField.text else { return true }
            let search = Edit.shared.searchQuery(nameForSearch: separeteText,
                                                   search: .reviw)
            
            textField.resignFirstResponder()
            textField.text = nil
            
            fetchData(url: search)
          }
        return true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 30, height: 400)
    }
}



