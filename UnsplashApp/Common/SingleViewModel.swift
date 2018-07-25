//
//  SingleViewModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 23.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class SingleViewModel: ListViewModel {
    
    private let client: APIClient
    
    var imageByID: ImageInfo?  {
        didSet {
            self.fetchPhoto()
        }
    }
    
    var photo: Photo? {
        didSet {
            self.isLoaded!()
        }
    }
    
    override init(client: APIClient) {
        self.client = client
        super.init(client: client)
    }
    
    func fetchImageByID(id: String) {
        if let client = self.client as? UnsplashClient {
            
            let endpoint = UnsplashEndpoint.photoByID(clientID: UnsplashClient.apiKey, photoID: id)
            
            client.fetchPhoto(endpoint: endpoint) { (either) in
                switch either {
                case .success(let image):
                    self.imageByID = image
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    override func fetchPhoto() {
        
        guard let photoData = try? Data(contentsOf: (self.imageByID?.urls.small)!) else {
            //   self.showError?(APIError.imageDownload)
            return
        }
        
        guard let photo = UIImage(data: photoData) else {
            // self.showError?(APIError.imageConvert)
            return
        }
        print(photo)
        self.photo = Photo(image: photo)
    }
}
