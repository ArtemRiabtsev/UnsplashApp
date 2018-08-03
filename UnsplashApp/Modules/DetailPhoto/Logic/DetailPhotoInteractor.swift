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
    
    //- - accessory func
    func errorMessage(_ error: Error ) -> String {
        
        switch error {
        case APIError.badResponse:
            return "bad response from the server"
        case APIError.jsonDecoder:
            return "could not convert data"
        case APIError.imageDownload:
            return "photo dowloading is failed"
        case APIError.imageConvert:
            return "could not convert data to photo"
        default:
            return error.localizedDescription
        }
    }
    
    func downloadPhotoWithCustomSize(id: String, size: CGSize) {
        
        let downloadManager = DownloadManager(delegate: self)
        
        let client = UnsplashClient(downloadManager)
        
        let viewModel = SingleViewModel(client: client)
        
        viewModel.fetchImageByIDWithCustomSize(id: id, width: Int(size.width), height: Int(size.height))
        
        viewModel.isFailed = { error in
            
            let message = self.errorMessage(error)
            self.presenter?.downloadFeiled(errorMessage: message)
        }
    }
}

extension DetailPhotoInteractor: DownloadDelegate {
    
    func downloadingIsFailed(_ error: Error){
        
        let message = self.errorMessage(error)
        self.presenter?.downloadFeiled(errorMessage: message)
    }
    
    // send download progress to presenter
    func downloadFinished(info: String) {
        
        self.presenter?.downloadFinished(info: info)
    }
    // send download progress to presenter
    func downloadProgressUpdate(for progress: Float) {
        
            self.presenter?.downloadProgress(progress: progress)
    }
}
