//
//  CriticViewCell.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 09.04.2022.
//

import UIKit

class CriticViewCell: UICollectionViewCell {
    @IBOutlet var imageCritic: UIImageView!
    @IBOutlet var nameCritic: UILabel!
    
    func configureCritic(with critic: ResultCritic) {
        nameCritic.text = critic.displayName
        
        if critic.multimedia?.resource?.src == nil {
            imageCritic.image = UIImage(named: "personIcon")
        }
        
        StorageData().fetchCachImage(with: critic.multimedia?.resource?.src,
                                     imageView: imageCritic) { [weak self] image in
            guard let self = self else { return }
            self.imageCritic.image = image
            if self.imageCritic.image == nil {
                self.imageCritic.image = UIImage(named: "personIcon")
            }
        }
    }
}
