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
    private var isPaginating = false
    private var startSearch = false
    private var offSet = 0
    private var nameForSearch = ""
    var reviews: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchData(url: reviewsJsonUrl)
        pullTorefresh()
        hideKeyboard()
    }
    
    private func setup() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchReviews.delegate = self
        collectionView.alwaysBounceVertical = true
    }
    
    func fetchData(url: String) {
        
        NetworkDataFetch.shared.fetchReview(urlString: url) { [weak self] reviewModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let reviewModel = reviewModel else { return }
                self.reviews = reviewModel
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
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
        offSet = 0
        startSearch = false
        isPaginating = false
        refreshControl.endRefreshing()
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func changeDate() {
        
        let dateSearch = Edit.shared.configureDate(toString: datePicker)
        
        let urlSerach = Edit.shared.searchQuery(nameForSearch: dateSearch,
                                                link: .date)
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
        profile.criticName = reviews?.results?[indexPath.row].byline
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
            startSearch = true
            guard let separeteText = textField.text else { return true }
            self.nameForSearch = separeteText
            let search = Edit.shared.searchQuery(nameForSearch: separeteText,
                                                 link: .reviw)
            
            textField.resignFirstResponder()
            textField.text = nil
            
            //Swipe to top
            if reviews?.results?.count != nil {
                collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath,
                                            at: .top,
                                            animated: true)
            }
            
            fetchData(url: search)
        }
        return true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            guard !isPaginating else { return }
            isPaginating = true
            offSet += 20
            
            var url = ""
            
            if startSearch {
                url = Edit.shared.searchQuery(with: self.offSet, nameForSearch: self.nameForSearch,
                                              link: .reviw)
            } else {
                url = Edit.shared.searchQuery(with: self.offSet, nameForSearch: "",
                                              link: .pagination)
            }
            
            NetworkDataFetch.shared.fetchReview(urlString: url) { [weak self] reviewModel, error in
                guard let self = self else { return }
                if error == nil {
                    guard let reviewModel = reviewModel?.results else { return }
                    
                    self.reviews?.results?.append(contentsOf: reviewModel)
                    self.collectionView.reloadData()
                    
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

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 30, height: 400)
    }
}



