//
//  MainScreenProtocols.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol MainScreenWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol MainScreenPresenterProtocol: class {

    var interactor: MainScreenInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol MainScreenInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol MainScreenInteractorInputProtocol: class {

    var presenter: MainScreenInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol MainScreenViewProtocol: class {

    var presenter: MainScreenPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
