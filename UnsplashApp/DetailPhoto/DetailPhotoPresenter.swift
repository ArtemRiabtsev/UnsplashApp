//
//  DetailPhotoPresenter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoPresenter: DetailPhotoPresenterProtocol, DetailPhotoInteractorOutputProtocol {

    weak private var view: DetailPhotoViewProtocol?
    var interactor: DetailPhotoInteractorInputProtocol?
    private let router: DetailPhotoWireframeProtocol

    init(interface: DetailPhotoViewProtocol, interactor: DetailPhotoInteractorInputProtocol?, router: DetailPhotoWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
