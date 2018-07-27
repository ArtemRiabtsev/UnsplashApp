//
//  DetailPhotoInteractor.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoInteractor: DetailPhotoInteractorInputProtocol {
   
    weak var presenter: DetailPhotoInteractorOutputProtocol?

   
    func loadPhoto(id: String) {
        let viewModel = SingleViewModel(client: UnsplashClient())
        viewModel.fetchImageByID(id: id)
        
        viewModel.isLoaded = {
            self.presenter?.didLoadPhoto(viewModel: viewModel)
        }
    }
    
}

extension DetailPhotoInteractor {
    func getPhoto(id: String) {
        loadPhoto(id: id)
    }
    func downloadPhotoWithCustomSize(id: String, size: CGSize) {
        let downloadManager = DownloadManager(delegate: self)
        
        let client = UnsplashClient(downloadManager)
        let viewModel = SingleViewModel(client: client)
        
        viewModel.fetchImageByIDWithCustomSize(id: id, width: Int(size.width), height: Int(size.height))
    }
}

extension DetailPhotoInteractor: DownloadDelegate {
    
    
    func downloadFinished() {
        print("IMAGE  SAVED")
    }
    
    
    func downloadProgressUpdate(for progress: Float) {
        // send to presenter
        
        print("PROGRESS \(progress)")
    }
}
