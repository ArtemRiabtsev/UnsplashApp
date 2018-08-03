//
//  SingleViewModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 23.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class SingleViewModel: ListViewModel {
    
    var imageByIdWithCustomSize: ImageInfo? {
        
        didSet {
            if let url = imageByIdWithCustomSize?.urls.custom {
                if let client = self.client as? UnsplashClient {
                    let endpoint = UnsplashEndpoint.downloadPhoto(url: url.absoluteString)
                    client.downloadPhoto(endpoint: endpoint)
                } else {
                    self.isFailed!(APIError.imageDownload)
                }
            }
        }
    }
//when prompted with fields of height and width, the answer is returned with additional URL to load photos with the specified size
    func fetchImageByIDWithCustomSize(id: String, width: Int, height: Int) {
        if let client = self.client as? UnsplashClient {
            
            let endpoint = UnsplashEndpoint.photoByIDWithCustomSize(clientID: UnsplashClient.apiKey, photoID: id, width: width, height: height)
            
            client.fetchPhoto(endpoint: endpoint) { (either) in
                switch either {
                case .success(let image):
                    self.imageByIdWithCustomSize = image
                case .error(let error):
                    self.isFailed!(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
