//
//  MainScreenInteractor.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

class MainScreenInteractor: MainScreenInteractorInputProtocol {
    weak var presenter: MainScreenInteractorOutputProtocol?
    var unsplashClient = UnsplashClient()

    func getImageList(page: Int) {
        
        self.loadImageList(page: page)
    }
    
    func searchImagesByKeyword(page: Int, keyword: String) {
        self.loadSearchResultImageList(page: page, keyword: keyword)
    }
    

    //load data from network
    func loadImageList(page: Int) {
        
        let viewModel = ListViewModel(client: self.unsplashClient)
        viewModel.fetchLatestImages(page: page)
        viewModel.isLoaded = {
            self.presenter?.didLoadList(imageList: viewModel)
        }
        viewModel.isFailed = { error in
            
            let message = self.errorMessage(error)
            
            self.presenter?.loadingIsFailed(errorMessage: message)
        }
     
    }
    func loadSearchResultImageList(page: Int, keyword: String) {
        let viewModel = ListViewModel(client: self.unsplashClient)
        viewModel.fetchImagesByKeyword(page: page, keyword: keyword)
        viewModel.isLoaded = {
           self.presenter?.didLoadImagesByKeyword(imageList: viewModel)
        }
    }
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
}
