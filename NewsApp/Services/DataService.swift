//
//  DataService.swift
//  NewsApp
//
//  Created by Miran Mendelski on 08.04.2024..
//

import UIKit
import Alamofire


public typealias EmptyCallback = () -> Void

public protocol NetworkConfigProtocol {
    var baseURL: String {get}
    var apiKey: String {get}
    var staticHeaders: [String:String] {get}
}

public protocol DataServiceProtocol {
    func fetch<T>(_ resource: Resource<T>, completion: @escaping (ServiceResult<T>)->Void)
}

private extension Alamofire.HTTPMethod {
    init (_ method: ResourceMethod) {
        switch method {
        case .get: self = .get
        case .post: self = .post
        case .delete: self = .delete
        case .put: self = .put
        case .patch: self = .patch
        }
    }
}

public protocol FailureHandler {
    func handle(response: DataResponse<Any>) -> Error?
}

private extension Alamofire.DataRequest {
    static func encoding(from encoding: ResourceEncoding) -> ParameterEncoding {
        switch encoding {
        case .json: return JSONEncoding.default
        case .urlEncodedInURL: return URLEncoding.default
        }
    }
}

private let arrayParametersKey = "arrayParametersKey"

extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return ["arrayParametersKey": self]
    }
}


public class DataService: DataServiceProtocol {
    
    private var networkConfig: NetworkConfigProtocol
    private typealias JsonResponse = DataResponse<Any>
    
    private var interceptors: [RequestInterceptor] = []
    
    public func add(_ interceptor: RequestInterceptor) {
        self.interceptors.append(interceptor)
    }
        
    public init(networkConfig: NetworkConfigProtocol) {
        self.networkConfig = networkConfig
    }
    
    
    public func fetch<T>(_ resource: Resource<T>, completion: @escaping (ServiceResult<T>) -> Void) {
        if resource.files == nil {
            fetch(restResource: resource, completion: completion)
        } else {
            upload(resource, paramsPartName: resource.paramsPartName, completion: completion)
        }
    }
    
    private func fetch<T>(restResource resource: Resource<T>, completion: @escaping (ServiceResult<T>)->Void) {
        createRequest(for: resource) { [weak self] request in
            
            request
                .validate()
                .responseJSON{ response in
                    self?.handle(response, whenFetching: resource, completion: completion)
                    }
                }
        }
    
    
private func handle<T>(_ response: JsonResponse, whenFetching resource: Resource<T>, completion: (ServiceResult<T>)->Void) {
    
    print("handle\(response)")
    print("res\(resource)")
    let response: DataResponse<Any> = self.interceptors.reduce(response) { response, interceptor in
        interceptor.intercept(response)
    }
    
    
    switch response.result {
    case .success(let json):
        self.parse(json, into: resource, completion: completion)
    case .failure(let error):
        self.handle(error, whenFetching: resource, response: response, completion: completion)
    }
}
    
    
    private func upload<T>(_ resource: Resource<T>, paramsPartName: String = "data", completion: @escaping (ServiceResult<T>)-> Void) {
        
        func encodeData(data: MultipartFormData) {
            
            do {
                
                if let params = resource.params {
                    if paramsPartName.count > 0 {
                        let paramsData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                        data.append(paramsData, withName: paramsPartName)
                    }
                    else {
                        for (key, value) in params {
                            if let string = value as? NSString {
                                if let d = string.data(using: String.Encoding.utf8.rawValue) {
                                    data.append(d , withName: key)
                                }
                            }
                        }
                    }
                }
                
                if let files = resource.files {
                    for file in files {
                        data.append(file.data, withName: file.name, fileName: file.name + file.extension, mimeType: file.mimeType)
                    }
                }
                
                
            } catch let error {
                completion(.failure(.other(error)))
            }
        }
        
        createRequest(for: resource) { request in
            
            Alamofire.upload(multipartFormData: encodeData, with: request.request!) { result in
                switch result {
                case .success(let request, _, _):
                    request
                        .validate()
                        .responseJSON { [weak self] response in
                            self?.handle(response, whenFetching: resource, completion: completion)
                    }
                case .failure(let error):
                    print("Error creating request: \(error)")
                    completion(.failure(.other(error)))
                }
            }
        }
    }
        
    
    private func getHeaders(completion: @escaping ([String: String])-> Void) {
        
        var headers = networkConfig.staticHeaders
        
        for interceptor in interceptors {
            interceptor.headers()?.forEach { (key, value) in
                headers[key] = value
            }
        }
        
        completion(headers)
    }
    
    
    private func createRequest<T>(for resource: Resource<T>, completion: @escaping (DataRequest) -> Void) {
        
        getHeaders { [weak self] headers in
            
            guard let `self` = self else { return }
         
            let path = resource.path.hasPrefix("http") ? resource.path : self.networkConfig.baseURL + resource.path
            print("miranpah\(path)")
            if let arrayParams = resource.arrayParams {
                var request = Alamofire.request( path,
                                                method: HTTPMethod(resource.method),
                                                parameters: arrayParams.asParameters(),
                                                encoding: Alamofire.DataRequest.encoding(from: resource.encoding),
                                                headers: headers)
                
                for interceptor in self.interceptors {
                    request = interceptor.intercept(request)
                }
                
                print("miranpah\(request)")
                
                completion(request)
            } else {
                
                var request = Alamofire.request( path,
                                                method: HTTPMethod(resource.method),
                                                parameters: resource.params,
                                                encoding: Alamofire.DataRequest.encoding(from: resource.encoding),
                                                headers: headers)
                
                for interceptor in self.interceptors {
                    request = interceptor.intercept(request)
                }
                
                print("reqmiran\(request)")
                completion(request)
            }
        }
    }

    
    private func parse<T>(_ json: JSON, into resource: Resource<T>, completion: (ServiceResult<T>)-> Void) {
        
        do {
            completion(.success(try resource.parse(json)))
        } catch let error as DictionaryExtractionError {
            print(error)
            completion(.failure(.cannotParse(error)))
        } catch let error {
            completion(.failure(.other(error)))
        }
    }
    
    private func handle<T>(_ error: Error, whenFetching resource: Resource<T>, response: JsonResponse, completion: (ServiceResult<T>)-> Void) {
        
        let errorCode = (error as NSError).code
        let cfError = CFNetworkErrors(rawValue: Int32(errorCode))
        
        
        
        completion(.failure(.noInternet))
    }
}

