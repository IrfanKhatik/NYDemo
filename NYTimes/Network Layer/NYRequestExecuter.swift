//
//  NYRequestExecuter.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import Foundation

enum NYNetworkError: Swift.Error {
    case invalidURL
    case noData
}

protocol NYRequestType {
    associatedtype NYResponseType: Codable
    var data: NYRequestData { get }
}

extension NYRequestType {
    func execute (
        dispatcher: NYNetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (NYResponseType) -> Void,
        onError: @escaping (Error) -> Void
        ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                do {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any] {
                        guard let status = jsonObject["status"] as? String, status == "OK" else {
                            onError(NYNetworkError.noData)
                            return
                        }
                        
                        if let results = jsonObject["results"] as? [[String:Any]] {
                            let resultData = try? JSONSerialization.data(withJSONObject:results)
                            let jsonDecoder = JSONDecoder()
                            let result = try jsonDecoder.decode(NYResponseType.self, from: resultData!)
                            DispatchQueue.main.async {
                                onSuccess(result)
                                return
                            }
                        }
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        onError(error)
                    }
                }
        },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
        }
        )
    }
}

protocol NYNetworkDispatcher {
    func dispatch(request: NYRequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

struct URLSessionNetworkDispatcher: NYNetworkDispatcher {
    static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    func dispatch(request: NYRequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: request.path) else {
            onError(NYNetworkError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            if let params = request.params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            onError(error)
            return
        }
        
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let _data = data else {
                onError(NYNetworkError.noData)
                return
            }
            
            onSuccess(_data)
            }.resume()
    }
}
