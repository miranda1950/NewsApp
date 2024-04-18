//
//  NewsApiService.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit


protocol NewsApiProtocol {
    func getTopNews(pageNumber: Int, completion: @escaping(ServiceResult<NewsResponse>) -> Void)
    func getSearchNews(pageNumber: Int, searchText: String, completion: @escaping(ServiceResult<NewsResponse>)-> Void)
    func getTotalResults(searchText: String, completion: @escaping(ServiceResult<NewsResponse>)-> Void)
}

final class NewsApiService: NewsApiProtocol {
  
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    
    func getTopNews(pageNumber: Int, completion: @escaping (ServiceResult<NewsResponse>) -> Void) {
        
//        gmail api 971028e0d179445a9b6960ecdad20593
        let resource = Resource<NewsResponse>(
            params: ["country": "us",
                     "pageSize": 10,
                     "page": pageNumber,
                     "apikey": "4ff856769e2b42d7914d0516aee511db"],
        path: "top-headlines",
        encoding: .urlEncodedInURL,
        method: .get
        )
        
        dataService.fetch(resource, completion: completion)
    }
    
    func getSearchNews(pageNumber: Int, searchText: String, completion: @escaping (ServiceResult<NewsResponse>) -> Void) {
        
//        gmail api 971028e0d179445a9b6960ecdad20593
        
        let resource = Resource<NewsResponse>(
            params: [
                     "pageSize": 10,
                     "page": pageNumber,
                     "q": searchText,
                     "searchIn":"title",
                     "sortBy": "publishedAt",
                     "apikey": "4ff856769e2b42d7914d0516aee511db"],
        path: "everything",
        encoding: .urlEncodedInURL,
        method: .get
        )
        
        dataService.fetch(resource, completion: completion)
        
    }
    
    func getTotalResults(searchText: String, completion: @escaping (ServiceResult<NewsResponse>) -> Void) {
        
//        gmail api 971028e0d179445a9b6960ecdad20593
        
        
        let resource = Resource<NewsResponse>(
            params: [
                     "pageSize": 10,
                     "q": searchText,
                     "searchIn":"title",
                     "sortBy": "publishedAt",
                     "apikey": "4ff856769e2b42d7914d0516aee511db"],
        path: "everything",
        encoding: .urlEncodedInURL,
        method: .get
        )
        
        dataService.fetch(resource, completion: completion)
    }
}
