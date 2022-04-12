//
//  ReviewCell.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class ReviewViewCell: UICollectionViewCell {
    
    var reviewContainer: Result!
    var onMoreInfoTap: ((_ :UIAlertController) -> Void)?
    
    @IBOutlet var imageReview: UIImageView!
    @IBOutlet var headerReview: UILabel!
    @IBOutlet var bodyReview: UILabel!
    @IBOutlet var criticProfile: UIButton!
    @IBOutlet var publishDate: UILabel!
    @IBOutlet var reviewLink: UIButton!
    
    
    var indexPath: IndexPath!
    
    @IBAction func reviewLinkPresed(_ sender: Any) {
        reviewLink.animatePulse()
        
        //Alert and follow link
        guard let urlReview = reviewContainer.link?.url else { return }
        guard let url = URL(string: urlReview) else { return }
        let alert = reviewLink.showAlerrt(message: urlReview, url: url)
        self.onMoreInfoTap?(alert)
        
    }
    
    @IBAction func criticProfilePresed(_ sender: Any) {}

    func configure(with review: Result,index : IndexPath) {
        //TODO: Asyn match
        indexPath = index
        reviewLink.borderButton()
        criticProfile.tintColor = #colorLiteral(red: 1, green: 0.6109753251, blue: 0.3491381705, alpha: 1)
        
        reviewContainer = review
        configureReviewFields()
        
        StorageData().fetchCachImage(with: review.multimedia?.src,
                                     imageView: imageReview) { image in
            self.imageReview.image = image
        }
        
        
    }
    
    func configureReviewFields() {
        criticProfile.setTitle("  \(reviewContainer.byline ?? "No Name")", for: .normal)
        publishDate.text = reviewContainer.dateUpdated
        bodyReview.text = reviewContainer.summaryShort
        headerReview.text =  reviewContainer.displayTitle
    }
    

}
