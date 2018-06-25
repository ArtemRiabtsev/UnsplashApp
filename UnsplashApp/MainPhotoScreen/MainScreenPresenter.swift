//
//  MainScreenPresenter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class MainScreenPresenter: MainScreenPresenterProtocol, MainScreenInteractorOutputProtocol {

    weak private var view: MainScreenViewProtocol?
    var interactor: MainScreenInteractorInputProtocol?
    private let router: MainScreenWireframeProtocol

    init(interface: MainScreenViewProtocol, interactor: MainScreenInteractorInputProtocol?, router: MainScreenWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
