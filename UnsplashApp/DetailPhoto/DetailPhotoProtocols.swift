//
//  DetailPhotoProtocols.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol DetailPhotoWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol DetailPhotoPresenterProtocol: class {

    var interactor: DetailPhotoInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol DetailPhotoInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol DetailPhotoInteractorInputProtocol: class {

    var presenter: DetailPhotoInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol DetailPhotoViewProtocol: class {

    var presenter: DetailPhotoPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
