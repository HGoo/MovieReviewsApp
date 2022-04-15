//
//  ProfileViewCell.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 12.04.2022.
//

import UIKit

class ProfileViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet var imageReview: UIImageView!
    @IBOutlet var headerReview: UILabel!
    @IBOutlet var bodyReview: UILabel!
    @IBOutlet var publishDate: UILabel!
    @IBOutlet var criticProfile: UIButton!
    @IBOutlet var reviewLink: UIButton!
    
    // MARK: - Publick Properties
    var onMoreInfoTap: ((_ :UIAlertController) -> Void)?
    var indexPath: IndexPath!
    var asyncIndex: Int!
    
    private var reviewContainer: Results!
    
    // MARK: - Methods
    func configure(with review: Results, index : IndexPath) {
        indexPath = index
        reviewLink.borderCritic()
    
        if review.multimedia?.src == nil {
            imageReview.image = UIImage(named: "notFound")
        }
        
        reviewContainer = review
        configureReviewFields()
        StorageData().fetchCachImage(with: review.multimedia?.src,
                                     imageView: imageReview) { image in
            self.asyncIndex = index.row
            self.equals(image)
        }
    }
    
    // MARK: - Private Methods
    private func configureReviewFields() {
        criticProfile.setTitle("  \(reviewContainer.byline ?? "No Name")", for: .normal)
        publishDate.text = reviewContainer.dateUpdated
        bodyReview.text = reviewContainer.summaryShort
        headerReview.text =  reviewContainer.displayTitle
        publishDate.text = Edit().cutDate(date: reviewContainer.dateUpdated)
    }
    
    private func equals(_ image: UIImage) {
        if self.asyncIndex == self.indexPath.row {
            self.imageReview.image = image
            //activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - IBActions
    @IBAction func reviewLinkPresed(_ sender: Any) {
        reviewLink.animatePulse()
        //Alert and follow link
        guard let urlReview = reviewContainer.link?.url else { return }
        guard let url = URL(string: urlReview) else { return }
        let alert = reviewLink.showAlerrt(message: urlReview, url: url)
        self.onMoreInfoTap?(alert)
    }
}
