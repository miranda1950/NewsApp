//
//  TopHeadlinesViewModel.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit

final class TopNewsViewModel {
    private let newsApiService: NewsApiProtocol
    
    var onGoToDetails :((Article) -> Void)?
    var onGotData:EmptyCallback?
    var onStartedActivty: EmptyCallback?
    var onEndedActivity: EmptyCallback?
    
    var newsData: NewsResponse?
    var article: [Article] = []
    private var isAllContentLoaded = false
    private var isFetchingData = false
    private var pageNumber = 0
    
    
    init(newsApiService: NewsApiProtocol) {
        self.newsApiService = newsApiService
    }
}

extension TopNewsViewModel {
    
    func loadNews() {
        pageNumber = 1
        loadMoreNews()
    }
    
    func loadMoreNews() {
        guard !isAllContentLoaded else { return }
        
        guard !isFetchingData else { return }
        
        getNewsData()
    }
    
    func getNewsData() {
        onStartedActivty?()
        
        guard !isAllContentLoaded else {
            return
        }
        
        isFetchingData = true
        
        newsApiService.getTopNews(pageNumber: pageNumber) { [weak self] result in
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
    
  
    
    func reloadData() {
        guard !isFetchingData else { return }
        isFetchingData = true
        pageNumber = 1
        isAllContentLoaded = false
        getNewsData()
    }
}
