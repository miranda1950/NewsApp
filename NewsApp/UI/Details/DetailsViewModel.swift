//
//  DetailsViewModel.swift
//  NewsApp
//
//  Created by Miran Mendelski on 13.04.2024..
//

import UIKit

final class DetailsViewModel {
    
    var article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    
    var newsImage: URL {
        
        guard let urlString = article.urlToImage, !urlString.isEmpty else {
                // Return a placeholder URL here
            return Article.defaultImage
            }
        
        guard let url = URL(string: urlString) else {
              
            return Article.defaultImage
           }
        
        return url
    }
    
    var title: String {
        return article.title
    }
    
    var description: String {
        guard let description = article.description  else {
            return "N/A"
        }
        
        return description
    }
    
    var author: String {
        guard let author = article.author  else {
            return "Unknown"
        }
        
        return author
    }
}
