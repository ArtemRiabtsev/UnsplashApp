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
    var view: DetailPhotoViewProtocol? { get set }
    var router: DetailPhotoWireframeProtocol? { get set }
    func setUpView(id: String)
}

// MARK: InteractorProtocol
protocol DownloadDelegate: class {
    func downloadProgressUpdate(for progress: Float)
    func downloadFinished(info: String)
    func downloadingIsFailed(_ error:Error)
}

protocol DetailPhotoInteractorOutputProtocol: class {

    func didLoadPhoto(viewModel: SingleViewModel)
    func downloadProgress(progress: Float)
    func downloadFinished(info: String)
    func downloadFeiled(errorMessage: String)
    /** Interactor -> Presenter */
}

protocol DetailPhotoInteractorInputProtocol: class {

    var presenter: DetailPhotoInteractorOutputProtocol? { get set }
    
    func downloadPhotoWithCustomSize(id: String, size: CGSize)
    
    func getPhoto(id: String)
    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol DetailPhotoViewProtocol: class {

    var presenter: DetailPhotoPresenterProtocol? { get set }
    var detailImageView: UIImageView! { get set}
    /** Presenter -> ViewController */
    func showDownloadProgress(progress: Float)
    func showPhoto(viewModel: SingleViewModel)
    func showDownloadInfo(info: String)
    func showErrorMessage(errorMessage: String)
}
