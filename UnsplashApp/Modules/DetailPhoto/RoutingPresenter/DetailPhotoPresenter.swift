//
//  DetailPhotoPresenter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoPresenter: DetailPhotoPresenterProtocol {

    var view: DetailPhotoViewProtocol?
    var interactor: DetailPhotoInteractorInputProtocol?
    var router: DetailPhotoWireframeProtocol?

    init(interface: DetailPhotoViewProtocol, interactor: DetailPhotoInteractorInputProtocol?, router: DetailPhotoWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func setUpView(id: String, image: UIImage) {
        self.view?.id = id
        self.view?.sendedImage = image
    }
    func downloadPhotoByIdWithSize(id: String, size: CGSize) {
        
        self.interactor?.downloadPhotoWithCustomSize(id: id, size: size)
    }
}
extension DetailPhotoPresenter: DetailPhotoInteractorOutputProtocol {

    func downloadProgress(progress: Float) {
        self.view?.showDownloadProgress(progress: progress)
    }
    func downloadFinished(info: String) {
        self.view?.showDownloadInfo(info: info)
    }
    func downloadFeiled(errorMessage: String) {
        self.view?.showErrorMessage(errorMessage: errorMessage)
    }

}
