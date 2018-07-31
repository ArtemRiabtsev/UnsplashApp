//
//  DetailPhotoPresenter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoPresenter: DetailPhotoPresenterProtocol, DetailPhotoInteractorOutputProtocol {
    
    var view: DetailPhotoViewProtocol?
    var interactor: DetailPhotoInteractorInputProtocol?
    var router: DetailPhotoWireframeProtocol?

    init(interface: DetailPhotoViewProtocol, interactor: DetailPhotoInteractorInputProtocol?, router: DetailPhotoWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func setUpView(id: String) {
        self.interactor?.getPhoto(id: id)
    }
    func didLoadPhoto(viewModel: SingleViewModel) {
        self.view?.showPhoto(viewModel: viewModel)
    }
    func downloadProgress(progress: Float) {
        self.view?.showDownloadProgress(progress: progress)
    }
    func downloadFinished(info: String) {
        self.view?.showDownloadInfo(info: info)
    }
}
