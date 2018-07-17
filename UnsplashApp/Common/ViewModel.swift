//
//  ViewModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 12.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class ViewModel {
    private let client: APIClient
    var searchResult: SearchObject?
    
    var images: Images = [] {
        didSet {
            self.fetchPhoto()
        }
    }
    var photos:[Photo] = []
    
    var isLoaded: (() -> Void)?
    
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchLatestImages(page: Int) {
        if let client = self.client as? UnsplashClient {
            
            let endpoint = UnsplashEndpoint.photos(clientID: UnsplashClient.apiKey, page: String(page))
            
            client.fetchList(endpoint: endpoint) { (either) in
                switch either {
                case .success(let images):
                    self.images = images
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    func fetchImagesByKeyword(page: Int, keyword: String) {
        if let client = self.client as? UnsplashClient {
            
            let endpoint = UnsplashEndpoint.searchByKeyword(clientID: UnsplashClient.apiKey, keyword: keyword, page: String(page))
            
            client.fetchSearchResult(endpoint: endpoint) { (either) in
                switch either {
                case .success(let searchRes):
                    self.searchResult = searchRes
                    self.images = (self.searchResult?.results)!
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    private func fetchPhoto() {
        
        let group = DispatchGroup()
        self.images.forEach { (photo) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                guard let photoData = try? Data(contentsOf: photo.urls.small) else {
                 //   self.showError?(APIError.imageDownload)
                    return
                }
                
                guard let photo = UIImage(data: photoData) else {
                    // self.showError?(APIError.imageConvert)
                    return
                }
                self.photos.append(Photo(image: photo))
                group.leave()
            }
        }        
        group.notify(queue: .main) {
            self.isLoaded!()
            
        }
    }
}
