//
//  TopNewsResponse.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit

struct NewsResponse: Codable {
    
    let totalResults: Int
    let articles: [Article]
    
}

struct Article: Codable {
    let author: String
    let title: String
    let description: String
}
