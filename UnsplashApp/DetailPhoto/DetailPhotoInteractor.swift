//
//  DetailPhotoInteractor.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

class DetailPhotoInteractor: DetailPhotoInteractorInputProtocol {
    
    weak var presenter: DetailPhotoInteractorOutputProtocol?

    func getPhoto(id: String) {
        loadPhoto(id: id)
    }
    func loadPhoto(id: String) {
        let viewModel = SingleViewModel(client: UnsplashClient())
        viewModel.fetchImageByID(id: id)
        
        viewModel.isLoaded = {
            self.presenter?.didLoadPhoto(viewModel: viewModel)
        }
    }
}
