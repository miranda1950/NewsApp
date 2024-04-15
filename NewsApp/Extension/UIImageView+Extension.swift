//
//  UIImageView+Extension.swift
//  NewsApp
//
//  Created by Miran Mendelski on 13.04.2024..
//

import UIKit
import Kingfisher


public extension UIImageView {
    
    
    
    func setImage(with url: URL, placeholder: UIImage) {
        self.kf.setImage(with: url, placeholder: placeholder)
    }
    
}

extension UIImage {
    
    static let placeholderImage = UIImage(named: "news")
}
