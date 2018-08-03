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
    case photoByID(clientID: String, photoID: String)
    case photoByIDWithCustomSize(clientID: String, photoID: String, width: Int, height: Int)
    case downloadPhoto(url: String)
    
    var baseURL: String {
        switch self {
        case .photos, .photoByID, .searchByKeyword, .photoByIDWithCustomSize:
            return "https://api.unsplash.com"
        case .downloadPhoto:
            return ""
        }
    }
    
    var path: String {
        
        switch self {
        case .photos:
            return "/photos"
        case .searchByKeyword:
            return "/search/photos"
        case .photoByID(_, let photoID):
            return "/photos/" + photoID
        case .photoByIDWithCustomSize(_,  let photoID, _, _):
            return "/photos/" + photoID
        case .downloadPhoto(let url):
            return url
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
        case .photoByID( let id, _):
            return[
                URLQueryItem(name: "client_id", value: id),
            ]
        case .photoByIDWithCustomSize(let id, _, let width, let height):
            return[
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "w", value: String(width)),
                URLQueryItem(name: "h", value: String(height))
            ]
        case .downloadPhoto:
            return []
        }
    }
}
