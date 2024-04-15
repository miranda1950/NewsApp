//
//  Resource.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import Foundation

public typealias JSON = Any

public enum ResourceMethod {
    
    case get
    case post
    case put
    case delete
    case patch
}

public enum ResourceEncoding {
    
    case urlEncodedInURL
    case json
    
}

public enum DictionaryExtractionError: Error {
    
    case nonexistantKey(String)
    case cannotCastValueToType(String)
    
}

public struct File {
    
    /// The file extension of the file (e.g. ".txt" or ".jpeg")
    public let `extension`: String
    
    /// The name of the part
    public let name: String
    
    /// The data inside the part
    public let data: Data
    
    /// The mime type of the part
    public let mimeType: String
    
    /// A data part to be uploaded via multipart upload.
    ///
    /// - Parameters:
    ///   - extension: The file extension of the file (e.g. ".txt" or ".jpeg")
    ///   - name: The name of the part
    ///   - data: The data inside the part
    ///   - mimeType: The mime type of the part
    public init(extension: String, name: String, data: Data, mimeType: String) {
        self.`extension` = `extension`
        self.name = name
        self.data = data
        self.mimeType = mimeType
    }
    
    /// Creates a JPEG image part with the specified name and data.
    public static func image(name: String, image: Data)-> File {
        return File(extension: ".jpeg", name: name, data: image, mimeType: "image/jpeg")
    }
}

public struct Resource<T> {
    public let params: [String:Any]?
    public let arrayParams: [Any]?
    public let path: String
    public let method: ResourceMethod
    public let encoding: ResourceEncoding
    public let files: [File]?
    public let parse: (JSON) throws -> T
    public let paramsPartName: String
    
    public init(params: [String : Any]? = nil, arrayParams: [Any]? = nil, path: String, method: ResourceMethod = .get, encoding: ResourceEncoding = .urlEncodedInURL, files: [File]? = nil, parse: @escaping (JSON) -> T?, paramsPartName: String = "data") {
        self.params = params
        self.arrayParams = arrayParams
        self.path = path
        self.method = method
        self.encoding = encoding
        self.files = files
        self.paramsPartName = paramsPartName
        
        self.parse = { json in
            guard let parsedValue = parse(json) else {
                throw DictionaryExtractionError.cannotCastValueToType("Cannot decode json")
            }
        return parsedValue
        }
    }
}

extension Resource where T: Swift.Decodable {
    
    /// Something that can be fetched from the network, contains
    /// all the data needed to perform a network request.
    ///
    /// - Parameters:
    ///   - params: the parameters
    ///   - paramsPartName: the name of the parameters data part in a
    ///         multipart upload (only required if `files` is not empty)
    ///   - files: files that will be uploaded via multipart with the request,
    ///         not required. If the value is anything other than `nil`, the
    ///         request will be treated as a multipart request.
    ///   - path: the path of the resource, does not include a base URL (example: "user/me")
    ///   - encoding: how to encode the parameters
    ///   - method: the HTTP REST method
    public init(
        params: [String: Any]? = nil,
        arrayParams: [Any]? = nil,
        paramsPartName: String = "data",
        files: [File]? = nil,
        path: String,
        encoding: ResourceEncoding = .urlEncodedInURL,
        method: ResourceMethod = .get) {
        
        self.params = params
        self.arrayParams = arrayParams
        self.path = path
        self.paramsPartName = paramsPartName
        self.files = files
        self.method = method
        self.encoding = encoding
        self.parse = { data in
            let decoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted, .fragmentsAllowed])
            return try decoder.decode(T.self, from: data)
        }
    }
    
}
