//
//  ReviewCell.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class ReviewViewCell: UICollectionViewCell {
    @IBOutlet var imageReview: UIImageView!
    @IBOutlet var headerReview: UILabel!
    @IBOutlet var bodyReview: UILabel!
    @IBOutlet var criticProfile: UIButton!
    @IBOutlet var publishDate: UILabel!
    @IBOutlet var reviewLink: UIButton!
    
    var onMoreInfoTap: ((_ :UIAlertController) -> Void)?
    var indexPath: IndexPath!
    var asyncIndex: Int!
    
    private var reviewContainer: Results!
    
    func configure(with review: Results, index : IndexPath) {
        //TODO: Asyn match
        indexPath = index
        reviewLink.borderButton()
        criticProfile.tintColor = #colorLiteral(red: 1, green: 0.6109753251, blue: 0.3491381705, alpha: 1)
        
        reviewContainer = review
        configureReviewFields()
        
        if review.multimedia?.src == nil {
            self.imageReview.image = UIImage(named: "notFound")
            return
        }
        
        StorageData().fetchCachImage(with: review.multimedia?.src,
                                     imageView: imageReview) { image in
            self.asyncIndex = index.row
            self.equals(image)
            
        }
    }

    private func configureReviewFields() {
        criticProfile.setTitle("  \(reviewContainer.byline ?? "No Name")", for: .normal)
        bodyReview.text = reviewContainer.summaryShort
        headerReview.text =  reviewContainer.displayTitle
        publishDate.text = Edit().cutDate(date: reviewContainer.dateUpdated)
    }
        
    private func equals(_ image: UIImage) {
        if self.asyncIndex == self.indexPath.row {
            self.imageReview.image = image
        }
    }
    
    @IBAction func reviewLinkPresed(_ sender: Any) {
        reviewLink.animatePulse()
        
        //Alert and follow link
        guard let urlReview = reviewContainer.link?.url else { return }
        guard let url = URL(string: urlReview) else { return }
        let alert = reviewLink.showAlerrt(message: urlReview, url: url)
        self.onMoreInfoTap?(alert)
        
    }
    
    @IBAction func criticProfilePresed(_ sender: Any) {}

}
