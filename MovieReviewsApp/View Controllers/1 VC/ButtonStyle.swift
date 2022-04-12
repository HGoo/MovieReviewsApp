//
//  ButtonStyle.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import UIKit

extension UIButton {
    
    func animatePulse() {
        let pulse =  CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.95
        pulse.toValue = 1
        layer.add(pulse, forKey: nil)
    }
    
    func borderButton() {
        //settings for reviewLink button
        tintColor = #colorLiteral(red: 1, green: 0.6109753251, blue: 0.3491381705, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 15
        layer.borderColor = #colorLiteral(red: 1, green: 0.6109753251, blue: 0.3491381705, alpha: 1)
    }
    
    func showAlerrt(message: String, url: URL) -> UIAlertController {
        
        let alert = UIAlertController(title: "Follow the link?",
                                      message: message,
                                      preferredStyle: .alert)
        
        let goAction = UIAlertAction(title: "Go", style: .default) {_ in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        alert.addAction(goAction)
        alert.addAction(cancelAction)
        
        return alert
    }

    
}
