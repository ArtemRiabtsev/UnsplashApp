//
//  APIClient.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 11.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

enum Either<T> {
    case success(T)
    case error(Error)
}

enum APIError: Error {
    case unknown
    case badResponse
    case jsonDecoder
    case imageDownload
    case imageConvert
}

protocol APIClient {
    var session: URLSession { get }
    func get<T: Codable>(request: URLRequest, completion: @escaping (Either<[T]>) -> Void )
}

extension APIClient {
    
    var session: URLSession {
        
        return URLSession.shared
    }
    
    
    func get<T: Codable>(request: URLRequest, completion: @escaping (Either<[T]>) -> Void ) {
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                
                completion(.error(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.error(APIError.badResponse))
                return
            }
         
            guard let value = try? JSONDecoder().decode([T].self, from: data!) else {
                completion(.error(APIError.jsonDecoder))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
}
