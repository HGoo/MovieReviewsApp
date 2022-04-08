//
//  ReviewCell.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet var imageReview: ReviewImage!
    @IBOutlet var headerReview: UILabel!
    
    func configure() {
        print("aeqwe")
        imageReview.image = UIImage(named: "aaa")
        headerReview.text = "aweawe"
    }
    
}
