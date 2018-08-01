//
//  ViewModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 12.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class ListViewModel {
    let client: APIClient
    var maxPage = 999
    var searchResult: SearchObject? = nil {
        didSet {
            self.maxPage = (searchResult?.total_pages)!
            self.images = (self.searchResult?.results)!
        }
    }
    
    var images: Images = [] {
        didSet {
            self.getPhoto()
        }
    }
    var photos:[Photo] = []
    
    var isLoaded: (() -> Void)?
    var isFailed: ((_ error:Error) -> Void)?
    
    
    
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
                    self.isFailed!(error)
                }
            }
        }
    }
    func fetchImagesByKeyword(page: Int, keyword: String) {
        if let client = self.client as? UnsplashClient {
            
            let endpoint = UnsplashEndpoint.searchByKeyword(clientID: UnsplashClient.apiKey, keyword: keyword, page: String(page))
            print(endpoint.request)
            client.fetchSearchResult(endpoint: endpoint) { (either) in
                switch either {
                case .success(let searchRes):
                    self.searchResult = searchRes
                case .error(let error):
                    print(error.localizedDescription)
                    self.isFailed!(error)
                }
            }
        }
    }
    ///////===================================================== !!!!!!!!!!!!!!!!!!!!!!!
    
    func getPhoto() {

        let group = DispatchGroup()
        self.images.forEach { (photo) in
            DispatchQueue.global(qos: .background).sync {

                group.enter()
                                
                guard let photoData = try? Data(contentsOf: photo.urls.small) else {
                    self.isFailed!(APIError.imageDownload)
                    return
                }
                
                guard let image = UIImage(data: photoData) else {
                    self.isFailed!(APIError.imageConvert)
                    return
                }
                let photo = Photo(image: image)
                
                self.photos.append(photo)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoaded!()
            
        }
    }
}
