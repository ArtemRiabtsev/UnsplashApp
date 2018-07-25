//
//  DetailPhotoProtocols.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

// MARK: WireFrameProtocol

protocol DetailPhotoWireframeProtocol: class {
    static func createModuleWithID(id: String) -> UIViewController
    func dismissDetail()
}

// MARK: PresenterProtocol

protocol DetailPhotoPresenterProtocol: class {
    var interactor: DetailPhotoInteractorInputProtocol? { get set }
    func setUpView(id: String)
}

// MARK: InteractorProtocol

protocol DetailPhotoInteractorOutputProtocol: class {

    func didLoadPhoto(viewModel: SingleViewModel)
    /** Interactor -> Presenter */
}

protocol DetailPhotoInteractorInputProtocol: class {

    var presenter: DetailPhotoInteractorOutputProtocol? { get set }

    func getPhoto(id: String) -> Void
    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol DetailPhotoViewProtocol: class {

    var presenter: DetailPhotoPresenterProtocol? { get set }
    var detailImageView: UIImageView! { get set}
    /** Presenter -> ViewController */
    func showPhoto(viewModel: SingleViewModel)
}
