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

    func getImageList(page: Int) {
        
        self.loadImageList(page: page)
    }
    
    func searchImagesByKeyword(page: Int, keyword: String) {
        self.loadSearchResultImageList(page: page, keyword: keyword)
    }
    

    //load data from network
    func loadImageList(page: Int) {
        
        let viewModel = ListViewModel(client: UnsplashClient())
        viewModel.fetchLatestImages(page: page)
        viewModel.isLoaded = {
            self.presenter?.didLoadList(imageList: viewModel)
        }
     
    }
    func loadSearchResultImageList(page: Int, keyword: String) {
        let viewModel = ListViewModel(client: UnsplashClient())
        viewModel.fetchImagesByKeyword(page: page, keyword: keyword)
        viewModel.isLoaded = {
           self.presenter?.didLoadImagesByKeyword(imageList: viewModel)
        }
    }
}
