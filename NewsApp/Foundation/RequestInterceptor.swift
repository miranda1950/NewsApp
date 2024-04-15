//
//  RequestInterceptor.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import Foundation
import Alamofire

public protocol RequestInterceptor {
    
    func headers()-> [String: String]?
    func intercept(_ request: DataRequest)-> DataRequest
    func intercept<T>(_ response: DataResponse<T>)-> DataResponse<T>
    
}

public extension RequestInterceptor {
    
    func intercept<T>(_ response: DataResponse<T>)-> DataResponse<T> {
        return response
    }
    
    func headers()-> [String: String]? {
        return nil
    }
    
}
