//
//  SingleViewModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 23.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class SingleViewModel: ListViewModel {
    
    var imageByID: ImageInfo?  {
        didSet {
            if let url = imageByID?.urls.custom {
                if let client = self.client as? UnsplashClient {
                    let endpoint = UnsplashEndpoint.downloadPhoto(url: url.absoluteString)
                    client.downloadPhoto(endpoint: endpoint)
                }
            } else {
                self.getPhoto()
            }
        }
    }
    
    var photo: Photo? {
        didSet {
            self.isLoaded!()
        }
    }

    func fetchImageByIDWithCustomSize(id: String, width: Int, height: Int) {
        if let client = self.client as? UnsplashClient {
            
            let endpoint = UnsplashEndpoint.photoByIDWithCustomSize(clientID: UnsplashClient.apiKey, photoID: id, width: width, height: height)
            
            client.fetchPhoto(endpoint: endpoint) { (either) in
                switch either {
                case .success(let image):
                    self.imageByID = image
                case .error(let error):
                    self.isFailed!(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
   
    override func getPhoto() {
        
        DispatchQueue.global(qos: .background).async {
            guard let photoData = try? Data(contentsOf: (self.imageByID?.urls.small)!) else {
                
                self.isFailed!(APIError.imageDownload)
                return
            }
            guard let photo = UIImage(data: photoData) else {
                self.isFailed!(APIError.imageConvert)
                return
            }
            DispatchQueue.main.async {
                 self.photo = Photo(image: photo)
            }
        }
    }
}
