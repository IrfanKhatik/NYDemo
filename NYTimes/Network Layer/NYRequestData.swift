//
//  NYRequestData.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}

struct NYRequestData {
    let path: String
    let method: HTTPMethod
    let params: [String: Any?]?
    let headers: [String: String]?
    
    init (path: String, method: HTTPMethod = .get, params: [String: Any?]? = nil, headers: [String: String]? = nil) {
        self.path       = path
        self.method     = method
        self.params     = params
        self.headers    = headers
    }
}
