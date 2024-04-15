//
//  SearchNewsViewModel.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import Foundation
import UIKit

final class SearchNewsViewModel {
    
    private let newsApiService: NewsApiProtocol
    
    
    var onGoToDetails :((Article) -> Void)?
    var onGotData:EmptyCallback?
    var onStartedActivty: EmptyCallback?
    var onEndedActivity: EmptyCallback?
    var newsData: NewsResponse?
    var article: [Article] = []
    var queryText: String = ""
    private var isAllContentLoaded = false
    private var isFetchingData = false
    private var pageNumber = 0
    
    init(newsApiService: NewsApiProtocol) {
        self.newsApiService = newsApiService
    }
    
}

extension SearchNewsViewModel {
    
    func loadNews(_ search: String) {
        pageNumber = 1
        loadMoreNews(search)
    }
    
    func loadMoreNews(_ search: String) {
        guard !isAllContentLoaded else { return }
        
        guard !isFetchingData else { return }
        
        getSearchNewsData(search)
    }
    
    func getSearchNewsData(_ search: String) {
        onStartedActivty?()
        
        guard !isAllContentLoaded else {
            return
        }
        
        isFetchingData = true
        
        newsApiService.getSearchNews(pageNumber: pageNumber, searchText: search) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.onEndedActivity?()
                if self.pageNumber == 1 {
                    self.article = value.articles
                } else {
                    self.article.append(contentsOf: value.articles)
                }
                
                if value.articles.count < 10 {
                    self.isAllContentLoaded = true
                } else {
                    self.pageNumber += 1
                }
                self.onGotData?()
                self.isFetchingData = false
            case .failure(let error):
                print("Failure getting data\(error)")
                self.onEndedActivity?()
                self.isFetchingData = false
            }
        }
    }
    
    
    
}
