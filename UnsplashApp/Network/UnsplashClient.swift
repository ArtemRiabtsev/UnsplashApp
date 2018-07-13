//
//  UnsplashClient.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 11.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

class UnsplashClient: APIClient {
    static let baseURL = "https://api.unsplash.com"
    static let apiKey = "78c7330e50470f59f78af971a2b3fa9dd93be90e05f83c1679c0f109d541cdc9"
    
    func fetch(endpoint: UnsplashEndpoint, completion: @escaping (Either<Images>) -> Void) {
        let request = endpoint.request
        print(request)////delete leter
        get(request: request, completion: completion)
        
    }
}
