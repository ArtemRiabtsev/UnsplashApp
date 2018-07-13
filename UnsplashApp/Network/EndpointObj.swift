//
//  EndpointObj.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 11.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        
        var urlComponents = URLComponents(string: self.baseURL)
        urlComponents?.path = self.path
        urlComponents?.queryItems = self.urlParameters
        
        return urlComponents!
    }
    
    
    var request: URLRequest {
        
        return URLRequest(url: urlComponents.url!)
    }
    
}

enum UnsplashEndpoint : Endpoint {

    case photos(clientID: String, page: String)
    case searchByKeyword(clientID: String, keyword: String, page: String)
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        
        switch self {
        case .photos:
            return "/photos"
        case .searchByKeyword:
            return "/search/photos"
        }
    }
    
    var urlParameters: [URLQueryItem] {
        
        switch self {
        case .photos(let id, let page):
            return[
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "page", value: page),
                URLQueryItem(name: "order_by", value: "latest")
            ]
        case .searchByKeyword(let id, let keyword, let page):
            return[
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "page", value: page),
                URLQueryItem(name: "query", value: keyword)
            ]
        }
    }
}
