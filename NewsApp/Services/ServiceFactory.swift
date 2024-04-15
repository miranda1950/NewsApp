//
//  ServiceFactory.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import Foundation


class ServiceFactory {
    
    static var dataService: DataServiceProtocol {
        let dataService = DataService(networkConfig: NetworkConfig())
        return dataService
    }
    
    static var newsApiService: NewsApiProtocol {
        return NewsApiService(dataService: dataService)
    }
}
