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
    let author: String?
    let title: String
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    
    
  

    
    var trimmedDate: String {
        
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        
        if let date = isoDateFormatter.date(from: publishedAt ?? "N/A") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            return dateFormatter.string(from: date)
        } else {
            return "N/A"
        }
    }
}
