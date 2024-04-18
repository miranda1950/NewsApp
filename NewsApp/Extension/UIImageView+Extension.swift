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
    static let defaultImage =  URL(string: "https://media.istockphoto.com/id/1369150014/vector/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=9pR2-nDBhb7cOvvZU_VdgkMmPJXrBQ4rB1AkTXxRIKM=")!
}
