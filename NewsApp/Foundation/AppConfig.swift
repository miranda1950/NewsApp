//
//  AppConfig.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import Foundation

struct AppConfig {
    
    enum PlistKey: String {
        case newsUrl
    }
    
    static fileprivate var infoDict: [String: Any] {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    static func configValue(_ key: PlistKey) -> String {
        return infoDict[key.rawValue] as! String
    }
}

struct NetworkConfig: NetworkConfigProtocol {
    let baseURL = "https://newsapi.org/v2/"
    let apiKey = "971028e0d179445a9b6960ecdad20593"
    let staticHeaders: [String : String] = [:]
    
}
