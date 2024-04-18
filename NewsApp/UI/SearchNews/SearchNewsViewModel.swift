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
    var onGotTotalResults:((String) -> Void)?
    var onStartedActivty: EmptyCallback?
    var onEndedActivity: EmptyCallback?
    var onNoInternet: EmptyCallback?
    
    var totalNewsNumber: Int = 0
    var lastPage = 0
    var article: [Article] = []
    var queryText: String = ""
    private var isAllContentLoaded = false
    private var isFetchingData = false
    var performedSearch = false
    var isSortAscending = false
    private var pageNumber = 0
    var sortType: SortType = .descending
    
    init(newsApiService: NewsApiProtocol) {
        self.newsApiService = newsApiService
    }
    
}

extension SearchNewsViewModel {
    
    func loadNews(_ search: String) {
        article = []
        isAllContentLoaded = false
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
        
        if sortType == .descending {
            newsApiService.getSearchNews(pageNumber: pageNumber, searchText: search) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.onEndedActivity?()
                    if self.pageNumber == 1  {
                        self.article = value.articles
                        
                    } else {
                        self.article.append(contentsOf: value.articles)
                        
                    }
                    if value.articles.count < 10  {
                        self.isAllContentLoaded = true
                    } else {
                        self.pageNumber += 1
                    }
                    self.onGotData?()
                    self.isFetchingData = false
                case .failure(let error):
                    print("Failure getting data\(error)")
                    self.onNoInternet?()
                    self.onEndedActivity?()
                    self.isFetchingData = false
                }
            }
        } else {
            newsApiService.getSearchNews(pageNumber: pageNumber, searchText: search) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.onEndedActivity?()
                    if self.pageNumber == lastPage {
                        self.article = value.articles.reversed()
                    } else {
                        self.article.append(contentsOf: value.articles.reversed())
                    }
                    if totalNewsNumber - value.articles.count < 10  {
                        self.isAllContentLoaded = true
                    } else {
                        if self.pageNumber > 1 {
                            self.pageNumber -= 1
                        } else {
                            self.isAllContentLoaded = true
                        }
                    }
                    self.onGotData?()
                    self.isFetchingData = false
                case .failure(let error):
                    print("Failure getting data\(error)")
                    self.onNoInternet?()
                    self.onEndedActivity?()
                    self.isFetchingData = false
                }
            }
        }
    }
    
    func getTotalResults(_ search: String) {
        newsApiService.getTotalResults(searchText: search) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.totalNewsNumber = value.totalResults
                self.pageNumber = self.getLastPage()
                self.onGotTotalResults?(search)
            case .failure(let error):
                print("Failure getting data\(error)")
                self.onNoInternet?()
                self.onEndedActivity?()
                self.isFetchingData = false
            }
        }
    }
    
    
    private func getLastPage() -> Int {
        if totalNewsNumber > 100 {
            lastPage = 10
            self.pageNumber = lastPage
            return lastPage
        } else {
            lastPage = (totalNewsNumber / 10)
            if totalNewsNumber % 10 != 0 {
                lastPage += 1
            }
            self.pageNumber = lastPage
            return lastPage
        }
    }
    
    func reloadData() {
        guard !isFetchingData else { return }
        isFetchingData = true
        switch sortType {
        case .ascending:
            pageNumber = lastPage
        case .descending:
            pageNumber = 1
        }
        isAllContentLoaded = false
        getSearchNewsData(queryText)
    }
}




enum SortType {
    case ascending
    case descending
}
