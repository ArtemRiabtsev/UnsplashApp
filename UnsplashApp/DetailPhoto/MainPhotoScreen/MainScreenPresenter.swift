//
//  MainScreenPresenter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class MainScreenPresenter: MainScreenPresenterProtocol, MainScreenInteractorOutputProtocol {

    var router: MainScreenWireframeProtocol?
    
    weak var view: MainScreenViewProtocol?
    var interactor: MainScreenInteractorInputProtocol?

    init(interface: MainScreenViewProtocol, interactor: MainScreenInteractorInputProtocol?, router: MainScreenWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func didLoadList(imageList: ListViewModel) {
        view?.showImageList(imageList: imageList)
    }
    
    func didLoadImagesByKeyword(imageList: ListViewModel) {
        view?.showImageList(imageList: imageList)
    }
    
    func setUpView(page: Int) {
        self.interactor?.getImageList(page: page)
    }
    
    func setUpViewWithSearchResult(page: Int, keyword: String) {
        self.interactor?.searchImagesByKeyword(page: page, keyword: keyword)
    }
}
