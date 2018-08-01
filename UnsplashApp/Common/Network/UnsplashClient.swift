//
//  UnsplashClient.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 11.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class UnsplashClient: APIClient {
    
    static let apiKey = "78c7330e50470f59f78af971a2b3fa9dd93be90e05f83c1679c0f109d541cdc9"
    
    var downloadManager: DownloadManager?
    
    
    func fetchList(endpoint: UnsplashEndpoint, completion: @escaping (Either<Images>) -> Void) {
        let request = endpoint.request
        get(request: request, completion: completion)
        
    }
    func fetchSearchResult(endpoint: UnsplashEndpoint, completion: @escaping (Either<SearchObject>) -> Void) {
        let request = endpoint.request
        get(request: request, completion: completion)
        
    }
    func fetchPhoto(endpoint: UnsplashEndpoint, completion: @escaping (Either<ImageInfo>) -> Void) {
        let request = endpoint.request
        get(request: request, completion: completion)
    }
    
    
    func downloadPhoto(endpoint: UnsplashEndpoint) {
        self.downloadManager?.download(path: endpoint.path)
    }
    convenience init(_ download:DownloadManager?) {
        self.init()
        self.downloadManager = download!
    }
}



